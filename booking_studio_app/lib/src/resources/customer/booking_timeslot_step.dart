import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/customer/booking_checkdata_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../shares/dialog.dart';
import '../shares/header.dart';

class BookingTimeSlotPage extends StatefulWidget {
  const BookingTimeSlotPage({Key? key, required this.service, required this.employee, required this.user}) : super(key: key);
  final Map service;
  final Map employee;
  final AuthModel user;

  @override
  State<BookingTimeSlotPage> createState() => _BookingTimeSlotPageState();
}

class _BookingTimeSlotPageState extends State<BookingTimeSlotPage> {
  List timeListOfEmployee = [];
  bool isLoading = false;
  String selectedTimeSlotIndex = "";

  @override
  void initState() {
    super.initState();
    getTimeSlotOfEmployee();
  }

  getTimeSlotOfEmployee() async {
    print("getTimeSlotOfEmployee...");
    var employeeId = widget.employee['id'];
    setState(() {
      isLoading = true;
    });
    var url = beEnvUrl + "/schedule/getBookingDayByEmployee?employeeId=${employeeId}";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var timeSlots = jsonDecode(response.body);
      setState(() {
        timeListOfEmployee = timeSlots; 
        isLoading = false;
      });
    } else {
      print("getTimeSlotOfEmployee... Fail");
      setState(() {
        timeListOfEmployee = [];
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
              Text("Choose Time", style: Styles.headerStepBookingTextStyle,
            )
          ),
          Gap(20),
          Expanded(child: getListTimeOfEmployee()),
          Gap(10),
          Container(
            height: 65,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: RaisedButton(
              onPressed: (){
                if (selectedTimeSlotIndex == "") {
                  showMessageWithOk(context, "Message", "Please select the time!");
                } else {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingCheckInformationPage(
                      user: widget.user,
                      service: widget.service,
                      employee: widget.employee,
                      timeSlot: selectedTimeSlotIndex,
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
                  Text("Book", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getListTimeOfEmployee(){
    if(timeListOfEmployee.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator()); 
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 1.1,
        mainAxisSpacing: 5
      ),
      itemCount: timeListOfEmployee.length,
      itemBuilder: (context, index){
      return getCard(timeListOfEmployee[index], context);
    });
  }

  Widget getCard(time, context){
    var timeSlot = time['myDays'].toString().split(' ');
    var day = timeSlot.last;
    var date = timeSlot.first.split('/');
    var dateShow = date[2] + "-" + date[1];
    var availableTime = time['available'];
    return GestureDetector(
      onTap: (){
        if(availableTime == true){
          setState(() {
            selectedTimeSlotIndex = time['myDays'];
          });
        } else {
          showMessageWithOk(context, "Time is Full", "Please choose another time!");
        }
      },
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: availableTime==true ? pinkLight : lightGrey,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selectedTimeSlotIndex == time['myDays'] ? lightBlueBorderColor : Colors.white
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(day, style: TextStyle(color: Colors.white, fontSize: 16),),
              Text(dateShow, style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
              Text(availableTime==true ? "Available" : "Full", style: TextStyle(color: Colors.white, fontSize: 16),)
            ],
          ),
        ),
      ),
    );
  }

}