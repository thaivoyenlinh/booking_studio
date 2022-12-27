import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/customer/appointment_schedule_finish.dart';
import 'package:booking_app/src/resources/customer/appointment_schedule_page.dart';
import 'package:booking_app/src/resources/customer/appointment_schedule_waiting_confirm_reschedule_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../../blocs/auth/parseJWT.dart';
import '../../models/customer/profile.model.dart';
import '../shares/header.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key, required this.user}) : super(key: key);
  final AuthModel user;
  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String accountId = "";
  bool isLoading = false;
  var customerDetails = "";

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  Future<ProfileModel> _getDetailsCustomer() async {
    print("_getDetailsCustomer...");
    String accountIdtmp = "";
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if (token != null) {
      final decode = parseJwt(token);
      accountIdtmp = decode["nameid"];
    }
    var url = beEnvUrl + "/customer/details?CustomerAccountId=${accountIdtmp}";
    var response = await http.post(Uri.parse(url));
    return ProfileModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDetailsCustomer(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
            var customer = snapshot.data as ProfileModel;
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
                      Tab(text: 'Appointment',),
                      Tab(text: 'Waiting Confirm Reschedule',),
                      Tab(text: 'Appointment History',),
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        AppointmentSchedulePage(user: widget.user, customerId: customer.id,),
                        AppointmentScheduleWaitingConformReschedulePage(user: widget.user, customerId: customer.id,),
                        AppointmentFinishPage(user: widget.user, customerId: customer.id),
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