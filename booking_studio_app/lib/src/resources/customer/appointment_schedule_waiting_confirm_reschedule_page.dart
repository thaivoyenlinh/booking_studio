import 'dart:convert';

import 'package:booking_app/src/resources/customer/reschedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../../models/auth_model.dart';

class AppointmentScheduleWaitingConformReschedulePage extends StatefulWidget {
  const AppointmentScheduleWaitingConformReschedulePage({Key? key, required this.user, required this.customerId}) : super(key: key);
  final AuthModel user;
  final int customerId;
  @override
  State<AppointmentScheduleWaitingConformReschedulePage> createState() => _AppointmentScheduleWaitingConformReschedulePageState();
}

class _AppointmentScheduleWaitingConformReschedulePageState extends State<AppointmentScheduleWaitingConformReschedulePage> {
  List<Item> _data = [];
  bool isLoading = false;
  List scheduleList = [];
  bool clkOnYes = false;
  bool? valueConfirmDeleteDialog = false;

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
    bool scheduleCompleted = false;
    bool waitingConfirmReschedule = true;
    var url = beEnvUrl + "/schedule/getSchedulesByCustomer?CustomerId=${widget.customerId}&ScheduleComplete=${scheduleCompleted}&WaitingConfirmReschedule=${waitingConfirmReschedule}";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      print("jsonDecode(response.body)");
      var schedules = jsonDecode(response.body);
      setState(() {
        scheduleList = schedules; 
        isLoading = false;
      });
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
          bool showButtonCancel = false;
          if(item.headerStatus == "WaitingConfirmRescheule"){
            showButtonCancel = true;
          }
          bool showRescheduleRow = true;
          if(item.headerStatus == "WaitingConfirmRescheule" && item.expandedDateReschedule != ""){
            showRescheduleRow = false;
          }
          return ExpansionPanel(
            backgroundColor: Color.fromARGB(255, 242, 237, 237),
            headerBuilder: (BuildContext context, bool isExpanded){
              return Container(
                height: 140,
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
                            image: NetworkImage(beEnvUrl + "/Images/" + item.headerImage)
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
                        SvgPicture.asset("assets/images/reschedule.svg", width: 20, color: primary),
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
                        Text(item.headerRescheduleType, style: TextStyle(color: Colors.orange),),
                        Gap(5),
                        Text( item.headerStatus == "WaitingConfirmRescheule" && item.expandedDateReschedule != "" ? item.expandedDateReschedule : item.headerDate, style: TextStyle(fontWeight: FontWeight.bold),),
                        Gap(5),
                        Text(item.headerNameEmployee),
                        Gap(5),
                        Text(item.headerPhoneNumberEmployee)
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
                  if(!showRescheduleRow)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Gap(30),
                      Text("Reschedule", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("From ", style: TextStyle(fontSize: 14),),
                          Text("To ", style: TextStyle(fontSize: 14),),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${item.headerDate}", style: TextStyle(fontSize: 14),),
                          Text("${item.expandedDateReschedule}", style: TextStyle(fontSize: 14),),
                        ],
                      ),
                      Gap(20)
                    ],
                  ),
                  Row(
                    children: [
                      Gap(40),
                      Text("Service", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Gap(40),
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
                      Gap(10),
                      if(!showButtonCancel)
                        Container(
                          child: ElevatedButton(
                            onPressed: () => clkCancel(item.scheduleId, item).whenComplete(() => {
                              setState(() {
                                scheduleList.remove(item);
                              })
                            }),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[400],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Cancel", style: TextStyle(
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

  Future<void> clkCancel(scheduleId, schedule) async {
    final value = await clkOnCancel();
    setState(() {
      valueConfirmDeleteDialog = value;
    });
    print("valueConfirmDeleteDialog");
    if(valueConfirmDeleteDialog == true) {
      var url = beEnvUrl + "/schedule/updateReschedule?ScheduleId=${scheduleId}&RescheduleType=1";
      var response = await http.post(Uri.parse(url));
      if(response.statusCode == 200){
        print("clkCancel... Success");
        _data.remove(schedule);
      } else {
        print("clkCancel... Fail");
      }
    }
  }

  Future<bool?> clkOnCancel() => showDialog<bool>(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text("Do you want to cancel this schedule?"),
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
          child: _buildListPanel(),
        ),
      )
    );
  }
}

class Item {
  String headerImage = "";
  String headerNameEmployee = "";
  String headerPhoneNumberEmployee = "";
  String headerDate = "";
  String headerStatus = "";
  String expandedServiceName = "";
  var expandedTotal = 0.0;
  bool isExpanded = false;
  var scheduleId = -1;
  String expandedDateReschedule = "";
  String headerRescheduleType = "";

  Item({
    required this.isExpanded, 
    required this.headerImage,
    required this.headerDate,
    required this.headerNameEmployee,
    required this.headerStatus,
    required this.headerPhoneNumberEmployee,
    required this.expandedServiceName,
    required this.expandedTotal,
    required this.scheduleId,
    required this.expandedDateReschedule,
    required this.headerRescheduleType
    });
}

List<Item> generateItem(scheduleListLenght, scheduleList){
  print(scheduleList);
  return List.generate(scheduleListLenght, (index) {
    Map schedule = scheduleList[index];
    return Item(
      scheduleId: schedule['id'],
      headerNameEmployee: schedule['employeeName'],
      headerPhoneNumberEmployee: schedule['employeePhoneNumber'],
      headerDate: schedule['date'],
      headerImage: schedule['employeeImage'],
      headerStatus: schedule['status'],
      expandedServiceName: schedule['serviceName'],
      expandedTotal: double.parse(schedule['total']),
      isExpanded: false,
      expandedDateReschedule: schedule['dateReschedule'] != null ? schedule['dateReschedule'] : "",
      headerRescheduleType: schedule['reScheduleType'] != null ? schedule['reScheduleType'] : ""
    );
  });
}