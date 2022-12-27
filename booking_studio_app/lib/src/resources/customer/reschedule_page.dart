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
import '../shares/dialog.dart';

class ReSchedulePage extends StatefulWidget {
  const ReSchedulePage({Key? key, required this.scheduleId, required this.user}) : super(key: key);
  final int scheduleId;
  final AuthModel user;
  @override
  State<ReSchedulePage> createState() => _ReSchedulePageState();
}

class _ReSchedulePageState extends State<ReSchedulePage> {
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
    print(url);
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
    final formatter = intl.NumberFormat.decimalPattern();
    return Scaffold(
      appBar: headerChild(context, titleText: "Reschedule"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: SingleChildScrollView(
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
                        SvgPicture.asset("assets/images/calendar.svg", width: 40, color: primary),
                        Text("Booking Days", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)
                      ],
                    ),
                    Gap(15),
                    SizedBox(
                       height: 100,
                      child: getListTimeOfEmployee()
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
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/details.svg", width: 33, color: primary),
                        Text("Customer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)
                      ],
                    ),
                    Gap(15),
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
                                Text("Appointment time")
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
                                Text(scheduleDetails['date'])
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
                    Row(
                      children: [
                        SvgPicture.asset("assets/images/details.svg", width: 33, color: primary),
                        Text("Employee Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 82, 80, 80)))
                      ],
                    ),
                    Gap(20),
                    Row(
                      children: [
                        Gap(20),
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
                                image: NetworkImage(beEnvUrl + "/Images/" + scheduleDetails['employeeImage'])
                            )
                          ),
                        ),
                        Gap(20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(scheduleDetails['employeeName'], style: TextStyle(fontWeight: FontWeight.bold),),
                            Gap(5),
                            Text(scheduleDetails['employeePhoneNumber']),
                            Gap(5),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
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
      ),
      bottomNavigationBar: Container(
              height: 65,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: RaisedButton(
                onPressed: clkOnUpdate,
                color: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Update", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),)
                  ],
                ),
              ),
            )
    );
  }

  clkOnUpdate() async {
    print("clkOnUpdate...");
    setState(() {
      isLoading = true;
    });
    var url = beEnvUrl + "/schedule/updateReschedule?ScheduleId=${widget.scheduleId}&RescheduleType=0&Days=${selectedTimeSlotIndex}";
    var response = await http.post(Uri.parse(url));
    if(response.statusCode == 200){
      setState(() {
        isLoading = false;
      });
      showMessageOkRatingPage(context, "Message", "You have successfully booked the service!", widget.user);
    } else {
      print("clkOnUpdate... Fail");
      setState(() {
        isLoading = false;
      });
      showMessageOkRatingPage(context, "Message", "You have failure booked the service!", widget.user);
    }
  }


  Widget getListTimeOfEmployee(){
    if(bookingDays.length < 0){
      return Center(child: CircularProgressIndicator()); 
    }
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
      ),
      itemCount: bookingDays.length,
      itemBuilder: (context, index){
      return getCard(bookingDays[index], context);
    });
  }

Widget getCard(time, context){
    var timeSlot = time['myDays'].toString().split(' ');
    var day = timeSlot.last;
    var date = timeSlot.first.split('/');
    var dateShow = date[2] + "-" + date[1];
    var availableTime = time['available'];
    var timebooked = scheduleDetails['date'];
    return GestureDetector(
      onTap: (){
        if(availableTime == true){
          setState(() {
            selectedTimeSlotIndex = time['myDays'];
          });
        } else if (availableTime == false && timebooked==time['myDays']) {
          showMessageWithOk(context, "This is the date you booked!", "Please choose another time!");
        } else {
          print(timebooked==timeSlot);
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




// class BookingDays{
//   final String myDays;
//   final bool available;
//   BookingDays({ required this.myDays, required this.available}) ;

//   factory BookingDays.fromJson(Map<String, dynamic> json){
//     return new BookingDays(
//       myDays: json['myDays'],
//       available: json['available'],
//     );
//   }
// }