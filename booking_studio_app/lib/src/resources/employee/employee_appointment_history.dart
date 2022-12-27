import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../../models/auth_model.dart';
import '../shares/dialog.dart';

class EmployeeAppointmentHistoryPage extends StatefulWidget {
  const EmployeeAppointmentHistoryPage({Key? key, required this.user, required this.employeeId}) : super(key: key);
  final AuthModel user;
  final int employeeId;  
  
  @override
  State<EmployeeAppointmentHistoryPage> createState() => _EmployeeAppointmentHistoryPageState();
}

class _EmployeeAppointmentHistoryPageState extends State<EmployeeAppointmentHistoryPage> {
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
    bool history = true;
    var url = beEnvUrl + "/schedule/getSchedulesByEmployee?EmployeeId=${widget.employeeId}&History=${history}";
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
          bool showCustomerRatingRow = true;
          if(item.headerStatus == "Cancelled"){
            showCustomerRatingRow = false;
          }
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
                    children: [
                      Gap(80),
                      if(showCustomerRatingRow)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rating for Staff"),
                              Gap(7),
                              Text("Rating for Service"),
                            ],
                          ),
                        ),
                      if(showCustomerRatingRow)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              showRating("employee", item.expandedEmployeeRating, item.scheduleId),
                              Gap(7),
                              showRating("service", item.expandedServiceRating, item.scheduleId),
                            ],
                          ),
                        ),
                      Gap(20)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Container(
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // Navigator.push(
                      //       //   context,
                      //       //   MaterialPageRoute(
                      //       //       builder: (context) => ReSchedulePage(scheduleId: item.scheduleId, user: widget.user,)),
                      //       // );
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Colors.green[300],
                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text("Confirm", style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16
                      //         ),)
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Gap(10),
                      // Container(
                      //   child: ElevatedButton(
                      //     onPressed: () => clkConfirm(item.scheduleId),
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Colors.green[300],
                      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text("Completed", style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16
                      //         ),)
                      //       ],
                      //     ),
                      //   ),
                      // ),
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

  Widget showRating(ratingFor, rating, scheduleId) {
    double ratingConvert = rating.toDouble();
    return RatingBar.builder( 
      ignoreGestures: true,
      initialRating: ratingConvert,
      minRating: 1,
      itemSize: 18,
      itemPadding: EdgeInsets.symmetric(horizontal: 2),
      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber,),
      updateOnDrag: true,
      onRatingUpdate: (rating) => setState(() {}),
    );
  } 

  Future<void> clkConfirm(scheduleId) async {
    print("clkCancel...");
    setState(() {
      isLoading = true;
    });
    var status = 2;
    var url = beEnvUrl + "/schedule/updateStatusSchedule?ScheduleId=${scheduleId}&Status=${status}";
    var response = await http.post(Uri.parse(url));
      if(response.statusCode == 200){
        print("clkCancel... Success");
        setState(() {
          isLoading = false;
        });
        showMessageWithOk(context, "Message", "Successful confirmation!");
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
          child: scheduleList.length > 0 ? _buildListPanel() : Center(child: Text("No schedule in history!"),),
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
  var expandedEmployeeRating = 0;
  var expandedServiceRating = 0;

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
    required this.expandedEmployeeRating,
    required this.expandedServiceRating
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
      expandedServiceName: schedule['serviceName'] != null ? schedule['serviceName'] : "Goi Special",
      expandedTotal: double.parse(schedule['total']),
      expandedEmployeeRating: schedule['employeeRating'] != null ? schedule['employeeRating'] : 0,
      expandedServiceRating: schedule['serviceRating'] != null ? schedule['serviceRating'] : 0,
      isExpanded: false
    );
  });
}