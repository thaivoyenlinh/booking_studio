import 'dart:convert';

import 'package:booking_app/src/blocs/auth/auth_bloc.dart';
import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/shares/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import '../../../environment.dart';
import '../../../utils/style.dart';

class EmployeeAppointmentPendingPage extends StatefulWidget {
  const EmployeeAppointmentPendingPage({Key? key, required this.user, required this.employeeId}) : super(key: key);
  final AuthModel user;
  final int employeeId;
  @override
  State<EmployeeAppointmentPendingPage> createState() => _EmployeeAppointmentPendingPageState();
}

class _EmployeeAppointmentPendingPageState extends State<EmployeeAppointmentPendingPage> {
  bool isLoading = false;
  List scheduleList = [];
  List<Item> _data = [];
  bool? valueConfirmDeleteDialog = false;
  bool clkOnYes = false;


  @override
  void initState() {
    getAppointment();
    super.initState();
  }

  getAppointment() async {
    print("getAppointment...");
    setState(() {
      isLoading = true;
    });
    bool history = false;
    var url = beEnvUrl + "/schedule/getSchedulesByEmployee?EmployeeId=${widget.employeeId}&Status=0&History=${history}";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print("jsonDecode(response.body)");
      var schedules = jsonDecode(response.body);
      setState(() {
        scheduleList = schedules; 
        isLoading = false;
      });
      print(scheduleList);
      _data = generateItem(scheduleList.length, scheduleList);
    } else {
      print("getAppointment... Fail");
      setState(() {
        scheduleList = [];
        isLoading = false;
      });
    }
  }

  Widget _buildListPanel(){
    final formatter = intl.NumberFormat.decimalPattern();
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _data[panelIndex].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item){
          return ExpansionPanel(
            backgroundColor: Color.fromARGB(255, 242, 237, 237),
            headerBuilder: (BuildContext context, bool isExpanded){
              return Container(
                height: 120,
                child: Row(
                  children: [
                    Gap(20),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: primary,
                          border: Border.all(color: lightGrey),
                          borderRadius: BorderRadius.circular(35),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(beEnvUrl + "/Images/Customers/" + item.headerImage)
                        )
                      ),
                    ),
                    Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(20),
                        SvgPicture.asset("assets/images/status.svg", width: 20, color: primary),
                        Gap(5),
                        SvgPicture.asset("assets/images/time.svg", width: 20, color: primary),
                        Gap(5),
                        SvgPicture.asset("assets/images/user.svg", width: 20, color: primary),
                        Gap(5),
                        SvgPicture.asset("assets/images/phone1.svg", width: 20, color: primary),
                      ],
                    ),
                    Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(20),
                        Text(item.headerStatus, style: TextStyle(color: Colors.orange),),
                        Gap(5),
                        Text(item.headerDate, style: TextStyle(fontWeight: FontWeight.bold),),
                        Gap(5),
                        Text(item.headerNameCustomer),
                        Gap(5),
                        Text(item.headerPhoneNumberCustomer)
                      ],
                    ),
                  ],
                ),
              );
            },
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Gap(15),
                  Row(
                    children: [
                      Gap(100),
                      Text("Service", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Gap(100),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.expandedServiceName, style: TextStyle(fontSize: 16),),
                            Gap(5),
                            Text("Total", style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(formatter.format(item.expandedTotal) + " VND"),
                            Gap(5),
                            Text(formatter.format(item.expandedTotal) + " VND", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primary))
                          ],
                        ),
                      ),
                      Gap(20)
                    ],
                  ),
                  Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: ElevatedButton(
                          onPressed: () => clkConfirm(item.scheduleId, item),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Confirm", style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),)
                            ],
                          ),
                        ),
                      ),
                      Gap(20)
                    ],
                  ),
                  Gap(15)
                ],
              ),
            ),
            isExpanded: item.isExpanded
            );
        }).toList()
    );
  }

  Future<void> clkConfirm(scheduleId, schedule) async {
    print("clkCancel...");
    setState(() {
      isLoading = true;
    });
    var status = 1;
    var url = beEnvUrl + "/schedule/updateStatusSchedule?ScheduleId=${scheduleId}&Status=${status}";
    var response = await http.post(Uri.parse(url));
      if(response.statusCode == 200){
        print("clkCancel... Success");
        setState(() {
          isLoading = false;
        });
        showMessageWithOk(context, "Message", "Successful confirmation!");
        _data.remove(schedule);
      } else {
        print("clkCancel... Fail");
        setState(() {
          isLoading = false;
        });
        showMessageWithOk(context, "Message", "Validation failure!");
      }
  }

  Future<bool?> clkOnCancel() => showDialog<bool>(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text("Do you want to delete this schedule?"),
      actions: [
        TextButton(
          onPressed: clkNoDialog,
          child: Text("No")
        ),
        TextButton(
          onPressed: clkYesDialog, 
          child: Text("Yes")
        )
      ],
    )
  );

  void clkNoDialog() {
    setState(() {
      clkOnYes = false;
    });
    Navigator.pop(context);
  }

  void clkYesDialog() {
    setState(() {
      clkOnYes = true;
    });
    Navigator.of(context).pop(clkOnYes);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SingleChildScrollView(
        child: Container(
          child: scheduleList.length > 0 ? _buildListPanel() : Center(child: Column(
            children: [
              Gap(300),
              Text("No schedule waiting for confirmation!"),
            ],
          ),),
        ),
      )
    );
  }
}

class Item {
  String headerImage = "";
  String headerNameCustomer = "";
  String headerPhoneNumberCustomer = "";
  String headerDate = "";
  String headerStatus = "";
  String expandedServiceName = "";
  var expandedTotal = 0.0;
  bool isExpanded = false;
  var scheduleId = -1;

  Item({
    required this.isExpanded, 
    required this.headerImage,
    required this.headerDate,
    required this.headerStatus,
    required this.headerNameCustomer,
    required this.headerPhoneNumberCustomer,
    required this.expandedServiceName,
    required this.expandedTotal,
    required this.scheduleId,
    });
}

List<Item> generateItem(scheduleListLenght, scheduleList){
  return List.generate(scheduleListLenght, (index) {
    Map schedule = scheduleList[index];
    return Item(
      scheduleId: schedule['id'],
      headerNameCustomer: schedule['customerName'],
      headerPhoneNumberCustomer: schedule['customerPhoneNumber'],
      headerDate: schedule['date'],
      headerImage: schedule['customerImage'],
      headerStatus: schedule['status'],
      expandedServiceName: schedule['serviceName'],
      expandedTotal: double.parse(schedule['total']),
      isExpanded: false
    );
  });
}