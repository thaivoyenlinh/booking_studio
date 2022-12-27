import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/customer/booking_timeslot_step.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:booking_app/utils/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import '../../../environment.dart';
import '../shares/dialog.dart';

class BookingEmployeePage extends StatefulWidget {
  const BookingEmployeePage({Key? key, required this.service, required this.user}) : super(key: key);
  final Map service;
  final AuthModel user;

  @override
  State<BookingEmployeePage> createState() => _BookingEmployeePageState();
}

class _BookingEmployeePageState extends State<BookingEmployeePage> {
  List employeeList = [];
  bool isLoading = false;
  int selectedEmployeeIndex = -1;
  dynamic employeeIndex = {"id": -1};

  @override
  void initState() {
    super.initState();
    getEmployeesByService();
  }

  getEmployeesByService() async {
    print("getEmployeesByService...");
    var serviceId = widget.service['id'];
    setState(() {
      isLoading = true;
    });
    var url = beEnvUrl + "/employee/getEmployeesByServiceId?serviceId=${serviceId}";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var services = jsonDecode(response.body);
      setState(() {
        employeeList = services; 
        isLoading = false;
      });
    } else {
      print("getEmployeesByService... Fail");
      setState(() {
        employeeList = [];
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
              Text("Choose Employee", style: Styles.headerStepBookingTextStyle,
            )
          ),
          Gap(20),
          Expanded(child: getListServices()),
          Container(
            height: 65,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: RaisedButton(
              onPressed: (){
                if(employeeIndex['id'] == -1){
                  showMessageWithOk(context, "Message", "Please select the employee!");
                } else {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingTimeSlotPage(
                      user: widget.user,
                      service: widget.service, 
                      employee: employeeIndex,
                      )
                    ),
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
    if(employeeList.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator()); 
    }
    return ListView.builder(
      itemCount: employeeList.length,
      itemBuilder: (context, index){
      Map employee= employeeList[index];
      return getCard(employee);
    });
  }

  Widget getCard(employee){
    var name = employee['name'];
    var email = employee['email'];
    var image = employee['image'];
    var id = employee['id'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          side:  BorderSide(
            width: 1.5,
            color: selectedEmployeeIndex==id ? lightBlueBorderColor : Colors.white,
          ),
        ),
        child: ListTile(
          title: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(beEnvUrl + "/Images/" + image)
                  )
                ),
              ),
              SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 18),),
                  SizedBox(height: 5,),
                  SizedBox(height: 5,),
                  Text(email, style: TextStyle(fontSize: 14, color: lightGrey))
                ],
              )
            ],
          ),
          onTap: () {
            setState(() {
              selectedEmployeeIndex = id;
              employeeIndex = employee;
            });
          },
        ),
      ),
    );
  }

}