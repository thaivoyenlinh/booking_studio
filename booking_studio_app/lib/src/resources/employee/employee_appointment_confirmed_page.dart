import 'dart:async';
import 'dart:convert';

import 'package:booking_app/src/models/employee/employee_appointment_confirm_model.dart';
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
import '../../models/employee/employee_appointment_confirm_model.dart';
import '../shares/dialog.dart';

class EmployeeAppointmentConfirmedPage extends StatefulWidget {
  const EmployeeAppointmentConfirmedPage(
      {Key? key, required this.user, required this.employeeId})
      : super(key: key);
  final AuthModel user;
  final int employeeId;

  @override
  State<EmployeeAppointmentConfirmedPage> createState() =>
      _EmployeeAppointmentConfirmedPageState();
}

class _EmployeeAppointmentConfirmedPageState
    extends State<EmployeeAppointmentConfirmedPage> {
  bool isLoading = false;
  bool? valueConfirmDeleteDialog = false;
  late List<EmployeeAppointmentConfirmModel> expansionItems;
  @override
  void initState() {
    getAppointment();
    super.initState();
  }

  Stream<List<EmployeeAppointmentConfirmModel>> getAppointment() async* {
    print("getAppointment...");
    bool history = false;
    var status = 1;
    var url = beEnvUrl +
        "/schedule/getSchedulesByEmployee?EmployeeId=${widget.employeeId}&Status=${status}&History=${history}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      yield result
          .map(((e) => EmployeeAppointmentConfirmModel.fromJson(e)))
          .toList();
    } else {
      print("getAppointment... Fail");
      throw Exception(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: getAppointment(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error");
        } else if (snapshot.data == null) {
          return Text("data null");
        } else {
          expansionItems =
              snapshot.data! as List<EmployeeAppointmentConfirmModel>;
          return SingleChildScrollView(
            child: Container(
              child: expansionItems.length > 0
                  ? ExpendedPanel(expansionItems: expansionItems, user: widget.user, employeeId: widget.employeeId,)
                  : Center(
                      child: Column(
                        children: [
                          Gap(300),
                          Text("No schedule!"),
                        ],
                      ),
                    ),
            ),
          );
          }
        }
      ,
    ));
  }
}

List<EmployeeAppointmentConfirmModel> generateItem(
    scheduleListLenght, scheduleList) {
  return List.generate(scheduleListLenght, (index) {
    EmployeeAppointmentConfirmModel schedule = scheduleList[index];
    return EmployeeAppointmentConfirmModel(
        customerImage: schedule.customerImage,
        customerName: schedule.customerName,
        customerPhoneNumber: schedule.customerPhoneNumber,
        date: schedule.date,
        dateReschedule: schedule.dateReschedule,
        isExpanded: false,
        rescheduleType: schedule.rescheduleType,
        id: schedule.id,
        serviceName: schedule.serviceName,
        status: schedule.status,
        updateTime: schedule.updateTime,
        total: schedule.total
        );
  });
}


class ExpendedPanel extends StatefulWidget {
  const ExpendedPanel({Key? key, required this.expansionItems, required this.user, required this.employeeId}) : super(key: key);
  final List<EmployeeAppointmentConfirmModel> expansionItems;
  final AuthModel user;
  final int employeeId;
  @override
  State<ExpendedPanel> createState() => _ExpendedPanelState();
}

class _ExpendedPanelState extends State<ExpendedPanel> {
  bool isLoading = false;
  bool clkOnYes = false;
  List<EmployeeAppointmentConfirmModel> employeeExpansionPanels = [];

  @override
  void initState() {
    super.initState();
    employeeExpansionPanels = generateItem(widget.expansionItems.length, widget.expansionItems);
  }

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat.decimalPattern();
    return ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            employeeExpansionPanels[panelIndex].isExpanded = !isExpanded; 
          });
        },
        children: employeeExpansionPanels
            .map<ExpansionPanel>((EmployeeAppointmentConfirmModel item) {
          return ExpansionPanel(
            isExpanded: item.isExpanded,
            backgroundColor: Color.fromARGB(255, 242, 237, 237),
            headerBuilder: (BuildContext context, bool isExpanded) {
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
                              image: NetworkImage(beEnvUrl +
                                  "/Images/Customers/" +
                                  item.customerImage))),
                    ),
                    Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(20),
                        SvgPicture.asset("assets/images/status.svg",
                            width: 20, color: primary),
                        Gap(5),
                        SvgPicture.asset("assets/images/time.svg",
                            width: 20, color: primary),
                        Gap(5),
                        SvgPicture.asset("assets/images/user.svg",
                            width: 20, color: primary),
                        Gap(5),
                        SvgPicture.asset("assets/images/phone1.svg",
                            width: 20, color: primary),
                      ],
                    ),
                    Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(20),
                        Text(
                          item.status,
                          style: TextStyle(color: Colors.orange),
                        ),
                        Gap(5),
                        Text(
                          item.dateReschedule != ""
                              ? item.dateReschedule
                              : item.date,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Gap(5),
                        Text("${item.customerName}"),
                        Gap(5),
                        Text(item.customerPhoneNumber)
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
                      Text("Service",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Gap(100),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.serviceName, style: TextStyle(fontSize: 16),),
                            Gap(5),
                            Text("Total", style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(formatter.format(item.total) + " VND"),
                            Gap(5),
                            Text(formatter.format(item.total) + " VND", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primary))
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
                      Container(
                        child: ElevatedButton(
                          onPressed: () => clkConfirm(item.id, item),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Completed", style: TextStyle(
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
            
          );
        }).toList());
  }

  Future<void> clkConfirm(scheduleId, schedule) async {
    print("clkCancel...");
    setState(() {
      isLoading = true;
    });
    var status = 2;
    var url = beEnvUrl +
        "/schedule/updateStatusSchedule?ScheduleId=${scheduleId}&Status=${status}";
    var response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      print("clkCancel... Success");
      setState(() {
        isLoading = false;
      });
      showMessageWithOk(context, "Message", "Successful confirmation!");
      employeeExpansionPanels.remove(schedule);
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
              TextButton(onPressed: clkNoDialog, child: Text("No")),
              TextButton(onPressed: clkYesDialog, child: Text("Yes"))
            ],
          ));

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

  Stream<List<EmployeeAppointmentConfirmModel>> getAppointment() async* {
    print("getAppointment...");
    bool history = false;
    var status = 1;
    var url = beEnvUrl +
        "/schedule/getSchedulesByEmployee?EmployeeId=${widget.employeeId}&Status=${status}&History=${history}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      yield result
          .map(((e) => EmployeeAppointmentConfirmModel.fromJson(e)))
          .toList();
    } else {
      print("getAppointment... Fail");
      throw Exception(response.reasonPhrase);
    }
  }

}