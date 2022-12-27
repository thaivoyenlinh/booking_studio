import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/customer/rating_page.dart';
import 'package:booking_app/src/resources/shares/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import '../../../environment.dart';
import '../../../utils/style.dart';

class AppointmentFinishPage extends StatefulWidget {
  const AppointmentFinishPage({Key? key, required this.user, required this.customerId}) : super(key: key);
  final AuthModel user;
  final int customerId;

  @override
  State<AppointmentFinishPage> createState() => _AppointmentFinishPageState();
}

class _AppointmentFinishPageState extends State<AppointmentFinishPage> {
  List<Item> _data = [];
  bool isLoading = false;
  List scheduleList = [];
  double ratingService = 0;
  double ratingEmployee = 0;

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
    bool scheduleCompleted = true;
    var url = beEnvUrl + "/schedule/getSchedulesByCustomer?CustomerId=${widget.customerId}&ScheduleComplete=${scheduleCompleted}";
    print(url);
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var schedules = jsonDecode(response.body);
      setState(() {
        scheduleList = schedules; 
        isLoading = false;
      });
      _data = generateItem(scheduleList.length, scheduleList);
    } else {
      print("getServices... Fail");
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
          bool hideRatingButton = false;
          bool showCustomerRatingRow = true;
          if(item.expandedEmployeeRating > 0 && item.expandedServiceRating > 0 || item.headerStatus == "Cancelled"){
            hideRatingButton = true;
          }
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
                  Row(
                    children: [
                      Gap(80),
                      Text("Service", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Gap(80),
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
                              Text("Your rating for Staff"),
                              Gap(7),
                              Text("Your rating for Service"),
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
                      if(!hideRatingButton)
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: RaisedButton(
                            onPressed: () => showRatingPage(item.scheduleId, item.expandedServiceName),
                            color: Colors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Rating", style: TextStyle(
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

  showRatingPage(Id, serviceName) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => RatingPage(scheduleId: Id, serviceName: serviceName, user: widget.user)
        ),
      );
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
  var expandedEmployeeRating = 0;
  var expandedServiceRating = 0;
  var scheduleId = -1;
  var expandedTotal = 0.0;
  bool isExpanded = false;
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
    required this.expandedEmployeeRating,
    required this.expandedServiceRating
    });
}

List<Item> generateItem(scheduleListLenght, scheduleList){
  return List.generate(scheduleListLenght, (index) {
    Map schedule = scheduleList[index];
    print(schedule);
    return Item(
      scheduleId: schedule['id'],
      headerNameEmployee: schedule['employeeName'],
      headerPhoneNumberEmployee: schedule['employeePhoneNumber'],
      headerDate: schedule['date'],
      headerImage: schedule['employeeImage'],
      headerStatus: schedule['status'],
      expandedServiceName: schedule['serviceName'] != null ? schedule['serviceName'] : "Goi Special",
      expandedTotal: double.parse(schedule['total']),
      expandedEmployeeRating: schedule['employeeRating'] != null ? schedule['employeeRating'] : 0,
      expandedServiceRating: schedule['serviceRating'] != null ? schedule['serviceRating'] : 0,
      isExpanded: false
    );
  });
}