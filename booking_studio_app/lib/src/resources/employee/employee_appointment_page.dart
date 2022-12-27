import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/models/employee/employee_profile.model.dart';
import 'package:booking_app/src/resources/employee/employee_appointment_confirmed_page.dart';
import 'package:booking_app/src/resources/employee/employee_appointment_history.dart';
import 'package:booking_app/src/resources/employee/employee_appointment_pending_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../../blocs/auth/parseJWT.dart';
import '../shares/header.dart';

class EmployeeAppointmentPage extends StatefulWidget {
  const EmployeeAppointmentPage({Key? key, required this.user}) : super(key: key);
  final AuthModel user;
  @override
  State<EmployeeAppointmentPage> createState() => _EmployeeAppointmentPageState();
}

class _EmployeeAppointmentPageState extends State<EmployeeAppointmentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);    
    super.initState();
  }

  Future<EmployeeProfileModel> _getDetailsEmployee() async {
    print("_getDetailsEmployee...");
    String accountIdtmp = "";
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if (token != null) {
      final decode = parseJwt(token);
      accountIdtmp = decode["nameid"];
    }
    var url = beEnvUrl + "/employee/details?EmployeeAccountId=${accountIdtmp}";
    var response = await http.post(Uri.parse(url));
    return EmployeeProfileModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmployeeProfileModel>(
      future: _getDetailsEmployee(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
            var employee= snapshot.data as EmployeeProfileModel;
            return Scaffold(
            appBar: headerChild(context, titleText: "Appointment schedule"),
            body: Container(
              child: Column(
                children: [
                  Gap(20),
                  TabBar(
                    unselectedLabelColor: lightGrey,
                    labelColor: primary,
                    tabs: [
                      Tab(text: 'Pending',),
                      Tab(text: 'Confirmed',),
                      Tab(text: "History")
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        EmployeeAppointmentPendingPage(user: widget.user, employeeId: employee.id,),
                        EmployeeAppointmentConfirmedPage(user: widget.user, employeeId: employee.id,),
                        EmployeeAppointmentHistoryPage(user: widget.user, employeeId: employee.id)
                        // AppointmentFinishPage(user: widget.user, customerId: customer.id),
                      ],
                      controller: _tabController,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
              return Center(child: Text("null data"));
            }
      } 
    );
  }
}