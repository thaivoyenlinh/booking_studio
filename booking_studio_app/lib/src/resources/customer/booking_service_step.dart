import 'dart:convert';

import 'package:booking_app/environment.dart';
import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/customer/booking_employee_step.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:booking_app/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../shares/dialog.dart';


class BookingServicePage extends StatefulWidget {
  const BookingServicePage({Key? key, required this.user}) : super(key: key);
  final AuthModel user;
  @override
  State<BookingServicePage> createState() => _BookingServicePageState();
}

class _BookingServicePageState extends State<BookingServicePage> {
  List servicesList = [];
  bool isLoading = false;
  int selectedServiceIndex = -1;
  dynamic serviceIndex = {"id": -1};

  @override
  void initState() {
    super.initState();
    getServices();
  }

  getServices() async {
    print("getServices...");
    setState(() {
      isLoading = true;
    });
    var url = beEnvUrl + "/service/pagination?CurrentPage=1&RowsPerPage=100";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var services = jsonDecode(response.body)['rows'];
      setState(() {
        servicesList = services; 
        isLoading = false;
      });
    } else {
      print("getServices... Fail");
      setState(() {
        servicesList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerChild(context, titleText: "Booking"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(30),
          Container(
            padding: EdgeInsets.only(left: 25),
            child: 
              Text("Choose Service", style: Styles.headerStepBookingTextStyle,
            )
          ),
          Gap(20),
          Expanded(child: getListServices()),
          Container(
            height: 65,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: RaisedButton(
              onPressed: (){
                if (serviceIndex['id'] == -1){
                  showMessageWithOk(context, "Message", "Please select the service!");
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingEmployeePage(user: widget.user,service: serviceIndex)),
                  );
                }
              },
              color: primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Next", style: TextStyle(
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
    );
  }

  Widget getListServices(){
    if(servicesList.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator()); 
    }
    return ListView.builder(
      itemCount: servicesList.length,
      itemBuilder: (context, index){
        Map service = servicesList[index];
      return getCard(service, index);
    });
  }

  Widget getCard(service, index){
    var serviceName = service['serviceName'];
    var price = service['price'];
    var serviceDetails = service['serviceDetails'];
    var image = service['banner'];
    var id = service['id'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          side:  BorderSide(
            width: 1.5,
            color: selectedServiceIndex==id ? lightBlueBorderColor : Colors.white,
          ),
        ),
        child: ListTile(
          title: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: primary,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(beEnvUrl + "/Images/Services/" + image)
                  )
                ),
              ),
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(serviceName, style: TextStyle(fontSize: 20),),
                  SizedBox(height: 5,),
                  Text(price.toString() + " VND", style: TextStyle(fontSize: 16, color: orange),),
                  SizedBox(height: 5,),
                  Text(serviceDetails, style: TextStyle(fontSize: 14, color: lightGrey))
                ],
              )
            ],
          ),
          onTap: () {
            setState(() {
              selectedServiceIndex = id;
              serviceIndex = service;
            });
          },
        ),
      ),
    );
  }
}


