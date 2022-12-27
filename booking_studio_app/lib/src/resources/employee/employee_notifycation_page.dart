import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../shares/dialog.dart';

class EmployeeNotifycationPage extends StatefulWidget {
  const EmployeeNotifycationPage({Key? key, required this.user, required this.employeeId}) : super(key: key);
  final AuthModel user;
  final int employeeId;
  @override
  State<EmployeeNotifycationPage> createState() => _EmployeeNotifycationPageState();
}

class _EmployeeNotifycationPageState extends State<EmployeeNotifycationPage> {
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
    var url = beEnvUrl + "/schedule/getSchedulesByEmployee?EmployeeId=${widget.employeeId}&Status=5";
    print(url);
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
      appBar: header(context, titleText: "Notify"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(30),
          getListServices(),
        ],
      ),
    );
  }

   Widget getListServices(){
    if(servicesList.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator()); 
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: servicesList.length,
      itemBuilder: (context, index){
        Map service = servicesList[index];
      return getCard(service, index);
    });
  }

  Widget getCard(service, index){
    print(service);
    var scheduleId = service['id'];
    var updateTime = service['updateTime'].toString().split('.')[0];
    var date = (updateTime.split(' ')[0]).split('-').sublist(1).join('-');
    var time = updateTime.split(' ')[1];
    var customerName = service['customerName'];
    var customerImage = service['customerImage'];
    var reScheduleType = service['reScheduleType'];
    var scheduleStatus = service['status'];
    var dateReschedule = service['dateReschedule'];
    var dateAppointment = service['date'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          tileColor: scheduleStatus == "WaitingConfirmRescheule" ? Colors.blue[100] : Colors.white,
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
              SizedBox(
                width: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reScheduleType=="Cancel" ? "${customerName} wants to cancel the appointment" : "${customerName} wants to update the appointment", style: TextStyle(fontSize: 14)),
                    Gap(5),
                    if(dateReschedule != null)
                    Text("${dateAppointment} ==> ${dateReschedule}", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${time} ${date}", style: TextStyle(fontSize: 13, color: lightGrey)),
                        Container(
                          height: 20,
                          width: 80,
                          child: ElevatedButton(
                            onPressed: scheduleStatus == "WaitingConfirmRescheule" ? () => clkConfirm(scheduleId, index) : null,
                            style: ElevatedButton.styleFrom(
                              primary: scheduleStatus == "WaitingConfirmRescheule" ? Colors.amber : Colors.green[300],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(scheduleStatus == "WaitingConfirmRescheule" ? "Confirm" : "Processed", style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10
                                ),)
                              ],
                            ),
                          ),
                        ),    
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          // onTap: () {
          //   print(scheduleId);
          //   setState(() {
          //     // selectedServiceIndex = id;
          //     serviceIndex = service;
          //   });
          // },
        ),
      ),
    );
  }

  Future<void> clkConfirm(scheduleId, index) async {
    print("clkCancel...");
    setState(() {
      isLoading = true;
    });
    var url = beEnvUrl + "/schedule/updateReschedule?ScheduleId=${scheduleId}";
    var response = await http.post(Uri.parse(url));
    if(response.statusCode == 200){
      print("servicesList.elementAt(index)");
      print(servicesList.elementAt(index));
      print(servicesList.elementAt(index)['id']);
      print(servicesList.elementAt(index)['reScheduleType']);
      print("clkConfirm... Success");
      setState(() {
        isLoading = false;
        if(servicesList.elementAt(index)['reScheduleType'] == 'UpdateTime'){
          servicesList.elementAt(index)['status'] = "Updated";
        } else {
          servicesList.elementAt(index)['status'] = "Cancelled";
        }
        // servicesList.elementAt(index)['status']
      });
      showMessageWithOk(context, "Message", "Successful confirmation!");
    } else {
      print("clkConfirm... Fail");
      setState(() {
        isLoading = false;
      });
      showMessageWithOk(context, "Message", "Failure confirmation!");
    }
  }
}