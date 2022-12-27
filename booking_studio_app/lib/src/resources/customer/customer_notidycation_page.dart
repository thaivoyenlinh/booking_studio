import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';

class CustomerNotifycationPage extends StatefulWidget {
  const CustomerNotifycationPage({Key? key, required this.user, required this.customerId}) : super(key: key);
  final AuthModel user;
  final int customerId;

  @override
  State<CustomerNotifycationPage> createState() => _CustomerNotifycationPageState();
}

class _CustomerNotifycationPageState extends State<CustomerNotifycationPage> {
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
    // print("getServices...");
    // setState(() {
    //   isLoading = true;
    // });
    // var url = beEnvUrl + "/schedule/getSchedulesByEmployee?EmployeeId=${widget.employeeId}&Status=5";
    // print(url);
    // var response = await http.get(Uri.parse(url));
    // if(response.statusCode == 200){
    //   var services = jsonDecode(response.body);
    //   setState(() {
    //     servicesList = services; 
    //     isLoading = false;
    //   });
    // } else {
    //   print("getServices... Fail");
    //   setState(() {
    //     servicesList = [];
    //     isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Notify"),
      
    );
  }
}