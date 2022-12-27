import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/employee/employee_details_schedule.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../shares/dialog.dart';

class EmployeeSchedulePlanPage extends StatefulWidget {
  const EmployeeSchedulePlanPage({Key? key, required this.user, required this.employeeId}) : super(key: key);
  final AuthModel user;
  final int employeeId;
  @override
  State<EmployeeSchedulePlanPage> createState() => _EmployeeSchedulePlanPageState();
}

class _EmployeeSchedulePlanPageState extends State<EmployeeSchedulePlanPage> {
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
    bool history = false;
    var url = beEnvUrl + "/schedule/getSchedulesByEmployee?EmployeeId=${widget.employeeId}&Status=1&History=${history}";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var services = jsonDecode(response.body);
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
      appBar: headerChild(context, titleText: "Schedule"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(30),  
          Expanded(child: getListServices()), 
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
      Map employee= servicesList[index];
      return getCard(employee);
    });
  }

  Widget getCard(service){
    var scheduleId = service['id'];
    var updateTime = service['updateTime'].toString().split('.')[0];
    var customerName = service['customerName'];
    var customerImage = service['customerImage'];
    var reScheduleType = service['reScheduleType'];
    var scheduleStatus = service['status'];
    var dateReschedule = service['dateReschedule'];
    var dateAppointment = service['date'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        // margin: EdgeInsets.zero,
        child: ListTile(
          tileColor: Colors.blue[50],
          title: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(beEnvUrl + "/Images/Customers/" + customerImage)
                  )
                ),
              ),
              SizedBox(width: 20,),
              Column(
                children: [
                  Text("Time: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),)
                ],
              ),
              Column(
                children: [
                  Text(dateReschedule != null ? dateReschedule : dateAppointment, style: TextStyle(color: Colors.amber, fontSize: 13),)
                ],
              )
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeDetailsSchedule(user: widget.user, 
                    scheduleId: scheduleId, 
                    dateReschdule: dateReschedule != null ? dateReschedule : dateAppointment,
                    scheduleDetails: service,
                  )),
              );
          },
        ),
      ),
    );
  }
}