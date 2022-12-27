import 'dart:collection';
import 'dart:convert';
import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../../blocs/auth/parseJWT.dart';
import '../shares/dialog.dart';

class EmployeeAddDayOffPage extends StatefulWidget {
  const EmployeeAddDayOffPage({Key? key, required this.user, required this.employeeId}) : super(key: key);
  final AuthModel user;
  final int employeeId;
  @override
  State<EmployeeAddDayOffPage> createState() => _EmployeeAddDayOffPageState();
}

class _EmployeeAddDayOffPageState extends State<EmployeeAddDayOffPage> {
  bool isLoading = false;
  var bookingDays = [];
  String selectedTimeSlotIndex = "";
  HashSet selectedItems = new HashSet();
  final TextEditingController _reasonController = new TextEditingController();

  @override
  void initState() {
    _getDetailsEmployee();
    super.initState();
  }

  _getDetailsEmployee() async {
      getDayOffByEmployee();
  }

  getDayOffByEmployee() async {
    print("getDayOffByEmployee...");
    setState(() {
      isLoading = true;
    });
    var url = beEnvUrl + "/absence/getDayOffDayByEmployee?employeeId=${widget.employeeId}";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var scheduleDetails = jsonDecode(response.body);
      setState(() {
        bookingDays = scheduleDetails;
        isLoading = false;
      });
    } else {
      print("getDayOffByEmployee... Fail");
      setState(() {;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerChild(context, titleText: "Add Day Off"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text("Choose a time off", style: TextStyle(fontSize: 20, color: lightGrey),)
                ],
              ),
              Gap(10),
              SizedBox(
                height: 300,
                child: getListTimeOfEmployee()
              ),
              Gap(30),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason',
                ),
              ),
              Gap(50),
              Row(
                  children: [
                    Container(
                      width: 160,
                      child: GestureDetector(
                        onTap: clkOnCancel,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          decoration: BoxDecoration(
                              border: Border.all(color: primary),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Gap(30),
                    Container(
                      width: 160,
                      child: GestureDetector(
                        onTap: clkOnSend,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Send Application",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  clkOnCancel() {
     Navigator.of(context).pop();
  }
  
  clkOnSend()async {
    print("clkOnSend");
    var baseURL = beEnvUrl;
    var url = baseURL + "/absence/addAbsence";
    var reason = _reasonController.text;
    var status = 0;
    if (reason.isNotEmpty && selectedItems.length > 0) {
      var body = jsonEncode({
        "employeeId": widget.employeeId,
        "date": selectedItems.toList(),
        "reason": reason,
        "status": status
      });
      print("jsonDecode(body)");
      print(jsonDecode(body));
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: body);
      var result = jsonDecode(response.body);
      print(result['message']);
      if (response.statusCode == 200) {
        print(response.statusCode);
        showMessageWithOkNavigateEmployeeHomePage(context, "Message", result['message'], widget.user);
      } else {
        showMessageWithOkNavigateEmployeeHomePage(context, "Message", result['message'], widget.user);
        print(response.statusCode);
      }
    } else {
      if(reason.isEmpty) {
        showMessageWithOk(context, "Message", "Please enter reason");
      } 
      if(selectedItems.length == 0){
        showMessageWithOk(context, "Message", "Please  time off");
      }
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
  
  void doMultiSelection(time){
    setState(() {
      if(selectedItems.contains(time)){
        selectedItems.remove(time);
      } else {
        selectedItems.add(time);
      } 
    });
  }

  Widget getCard(time, context){
    var timeSlot = time['dayOff'].toString().split(' ');
    var day = timeSlot.last;
    var date = timeSlot.first.split('/');
    var dateShow = date[2] + "-" + date[1];
    var availableTime = time['available'];
    // var timebooked = scheduleDetails['date'];
    return GestureDetector(
      onTap: (){
        if(availableTime == false){
          showMessageWithOk(context, "You have applied for leave at this time", "Please choose another time!");
        } else {
          doMultiSelection(time['dayOff']);
        }
      },
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: availableTime==true ? pinkLight : lightGrey,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 2.5,
              color: lightBlueBorderColor.withOpacity(selectedItems.contains(time['dayOff']) ? 1 : 0)
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(day, style: TextStyle(color: Colors.white, fontSize: 16),),
              Text(dateShow, style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
              Text(availableTime==true ? "Available" : "Day Off", style: TextStyle(color: Colors.white, fontSize: 16),)
            ],
          ),
        ),
      ),
    );
  }
}