import 'dart:convert';

import 'package:booking_app/environment.dart';
import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import '../../blocs/auth/parseJWT.dart';
import '../shares/dialog.dart';
import '../shares/header.dart';

class BookingCheckInformationPage extends StatefulWidget {
  const BookingCheckInformationPage({Key? key, required this.timeSlot, required this.service, required this.employee, required this.user}) : super(key: key);
  final Map service;
  final Map employee;
  final String timeSlot;
  final AuthModel user;
  @override
  State<BookingCheckInformationPage> createState() => _BookingCheckInformationPageState();
}

class _BookingCheckInformationPageState extends State<BookingCheckInformationPage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  clkOnConfirm() async {
    print("clkOnConfirm...");
    final storage = new FlutterSecureStorage();
    // print("service: ${widget.service}");
    setState(() {
      isLoading = true;
    });
    var customerId = await storage.read(key: 'customerId');
    var status = "Pending";
    Map data = {
        "customerId": customerId, 
        "employeeId": widget.employee['id'].toString(),
        "serviceId": widget.service['id'].toString(),
        "date": widget.timeSlot,
        "status": status,
        "total": widget.service['price'].toString()
      };
    var url = beEnvUrl + "/schedule/add";
    var response = await http.post(Uri.parse(url), body: data);
    if(response.statusCode == 200){
      setState(() {
        isLoading = false;
      });
      showMessageWithOkNavigateHomePage(context, "Message", "You have successfully booked the service!", widget.user);
    } else {
      print("clkOnConfirm... Fail");
      setState(() {
        isLoading = false;
      });
      showMessageWithOkNavigateHomePage(context, "Message", "You have failure booked the service!", widget.user);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerChild(context, titleText: "Booking"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            CustomerDetailsCard(service: widget.service, timeSlot: widget.timeSlot),
            Gap(20),
            EmployeeDetailsCard(service: widget.service, employee: widget.employee, timeSlot: widget.timeSlot),
            Gap(20),
            ServiceDetailsCard(service: widget.service,),
            Spacer(),
            Container(
              height: 65,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: RaisedButton(
                onPressed: clkOnConfirm,
                color: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Confirm Booking", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ServiceDetailsCard extends StatelessWidget {
  const ServiceDetailsCard({
    Key? key, required this.service,
  }) : super(key: key);
  final Map service;

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat.decimalPattern();
    return Container(
      width: 500,
      decoration: BoxDecoration(
        border: Border.all(
          color: lightGrey
        ),  
      ),
      child: Column(
        children: [
          Gap(10),
          Row(
            children: [
              Gap(10),
              SvgPicture.asset("assets/images/photo.svg", width: 30, color: primary),
              Gap(10),
              Text("Service Booking", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 82, 80, 80)))
            ],
          ),
          Gap(20),
          Row(
            children: [
              Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(service['serviceName']),
                    
                    Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatter.format(service['price'])),
                    Divider(color: Colors.black),
                    Text(formatter.format(service['price']), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                  ],
                ),
              ),
              Gap(20)
            ],
          ),
          Gap(10)
        ],
      ),
    );
  }
}

class CustomerDetailsCard extends StatefulWidget {
  const CustomerDetailsCard({
    Key? key, required this.service, required this.timeSlot,
  }) : super(key: key);

  final Map service;
  final String timeSlot;

  @override
  State<CustomerDetailsCard> createState() => _CustomerDetailsCardState();
}

class _CustomerDetailsCardState extends State<CustomerDetailsCard> {
  late String accountId = "";
  var customerDetails = {};
  bool isLoading = false;

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  _getToken() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if (token != null) {
      final decode = parseJwt(token);
      setState(() {
        accountId = decode["nameid"];
      });
      _getDetailsCustomer();
    }
  }

  _getDetailsCustomer() async {
    print("_getDetailsCustomer...");
    final storage = new FlutterSecureStorage();
    setState(() {
      isLoading = true;
    });
    var url = beEnvUrl + "/customer/details?CustomerAccountId=${accountId}";
    var response = await http.post(Uri.parse(url));
    if(response.statusCode == 200){
      var customer = jsonDecode(response.body);
      var customerId = customer['id'].toString();
      await storage.write(key: 'customerId', value: customerId);
      setState(() {
        customerDetails = customer; 
        isLoading = false;
      });
    } else {
      print("_getDetailsCustomer... Fail");
      setState(() {
        customerDetails = {};
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Center(child: CircularProgressIndicator()); 
    }
    return Container(
      width: 500,
      decoration: BoxDecoration(
        border: Border.all(
          color: lightGrey
        ),  
      ),
      child: Column(
        children: [
          Gap(10),
          Row(
            children: [
              Gap(10),
              SvgPicture.asset("assets/images/details.svg", width: 30, color: primary),
              Gap(10),
              Text("Customer Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 82, 80, 80)))
            ],
          ),
          Gap(20),
          Row(
            children: [
              Gap(20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name", style: TextStyle(fontWeight: FontWeight.bold),),
                      Gap(5),
                      Text("Your Phone"),
                      Gap(5),
                      Text("Time Booking")
                    ],
                  ),
                  Gap(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customerDetails['fullName'], style: TextStyle(fontWeight: FontWeight.bold),),
                      Gap(5),
                      Text(customerDetails['phoneNumber']),
                      Gap(5),
                      Text(widget.timeSlot)
                    ],
                  )
                ],
              )
            ],
          ),
          Gap(10)
        ],
      ),
    );
  }
}

class EmployeeDetailsCard extends StatelessWidget {
  const EmployeeDetailsCard({
    Key? key, required this.service, required this.employee, required this.timeSlot,
  }) : super(key: key);

  final Map service;
  final Map employee;
  final String timeSlot;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        border: Border.all(
          color: lightGrey
        )
      ),
      child: Column(
        children: [
          Gap(10),
          Row(
            children: [
              Gap(10),
              SvgPicture.asset("assets/images/details.svg", width: 30, color: primary),
              Gap(10),
              Text("Employee Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 82, 80, 80)))
            ],
          ),
          Gap(20),
          Row(
            children: [
              Gap(20),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(45),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(beEnvUrl + "/Images/" + employee['image'])
                  )
                ),
              ),
              Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(employee['name'], style: TextStyle(fontWeight: FontWeight.bold),),
                  Gap(5),
                  Text(employee['phoneNumber']),
                  Gap(5),
                  Text(timeSlot)
                ],
              ),
            ],
          ),
          Gap(10)
        ],
      ),
    );
  }
}