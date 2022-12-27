import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import '../../../environment.dart';
import '../../../utils/style.dart';

class EmployeeDetailsSchedule extends StatefulWidget {
  const EmployeeDetailsSchedule({Key? key, required this.user, required this.scheduleId, required this.dateReschdule, required this.scheduleDetails}) : super(key: key);
  final AuthModel user;
  final int scheduleId;
  final String dateReschdule;
  final Map scheduleDetails;
  @override
  State<EmployeeDetailsSchedule> createState() => _EmployeeDetailsScheduleState();
}

class _EmployeeDetailsScheduleState extends State<EmployeeDetailsSchedule> {

  bool isLoading = false;
  var bookingDays = [];
  var scheduleDetails = {};
  String selectedTimeSlotIndex = "";


  @override
  void initState() {
    getScheduleDetails();
    super.initState();
  }

  getScheduleDetails() async {
    print("getScheduleDetails...");
    setState(() {
      isLoading = true;
    });
    bool scheduleCompleted = false;
    var url = beEnvUrl + "/schedule/getScheduleDetais?scheduleId=${widget.scheduleId}";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print("jsonDecode(response.body)");
      print(jsonDecode(response.body));
      var scheduleDetails = jsonDecode(response.body);
      var bookingDaysList = scheduleDetails['employeeBookingDays'];
      setState(() {
        this.scheduleDetails = scheduleDetails;
        bookingDays = bookingDaysList;
        isLoading = false;
      });
    } else {
      print("getScheduleDetails... Fail");
      setState(() {;
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    print("scheduleDetails");
    print(scheduleDetails);
    final formatter = intl.NumberFormat.decimalPattern();
    return Scaffold(
      appBar: headerChild(context, titleText: "Details Schedule"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: lightGrey
                    ),  
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/images/details.svg", width: 33, color: primary),
                          Text("Customer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)
                        ],
                      ),
                      Gap(15),
                      Row(
                        children: [
                          Gap(5),
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: lightGrey
                                    ), 
                                    color: primary,
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(beEnvUrl + "/Images/Customers/" + scheduleDetails['customerImage'])
                                  )
                                ),
                              ),
                              Gap(10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                                  Gap(5),
                                  Text("Phone Number", style: TextStyle( fontSize: 13)),
                                  Gap(5),
                                  Text("Appointment time", style: TextStyle( fontSize: 13)),
                                  Gap(5),
                                  if(widget.scheduleDetails['reScheduleType']  != null)
                                  Text("Reschedule", style: TextStyle( fontSize: 13))
                                ],
                              ),
                              Gap(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(scheduleDetails['customerName'], style: TextStyle(fontWeight: FontWeight.bold),),
                                  Gap(5),
                                  Text(scheduleDetails['customerPhoneNumber']),
                                  Gap(5),
                                  Text(widget.dateReschdule),
                                  Gap(5),
                                  if(widget.scheduleDetails['reScheduleType']  != null)
                                  Text(widget.scheduleDetails['reScheduleType'], style: TextStyle(color: Color.fromARGB(255, 91, 154, 18)),)
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ),
                Gap(20),
        
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                              Text(scheduleDetails['serviceName']),
                              Divider(color: Colors.black),
                              Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(formatter.format(double.parse(scheduleDetails['total'])) + " VND"),
                              Divider(color: Colors.black),
                              Text(formatter.format(double.parse(scheduleDetails['total'])) + " VND", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                            ],
                          ),
                        ),
                        Gap(20)
                      ],
                    ),
                    Gap(10)
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}