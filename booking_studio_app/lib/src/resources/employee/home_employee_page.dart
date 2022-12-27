import 'dart:convert';

import 'package:booking_app/src/resources/employee/employee_bottom_navigation_bar.dart';
import 'package:booking_app/src/resources/employee/employee_home_page.dart';
import 'package:booking_app/src/resources/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../blocs/auth/parseJWT.dart';
import '../../models/auth_model.dart';
import '../../models/employee/employee_profile.model.dart';

class HomeEmployeePage extends StatefulWidget {
  const HomeEmployeePage({Key? key, required this.user}) : super(key: key);
  final AuthModel user;

  @override
  State<HomeEmployeePage> createState() => _HomeEmployeePageState();
}

class _HomeEmployeePageState extends State<HomeEmployeePage> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async{
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if(token!= null){
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  Future<EmployeeProfileModel> _getDetailsEmployee() async {
    print("_getDetailsCustomer...");
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
            body: this._isLoggedIn ? EmployeeHomePage(user: widget.user) : LoginPage(),
            bottomNavigationBar: EmployeeBottomNavigationBar(user: widget.user, employee: employee,)
          );
        } else if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text(""));
        } else {
            return Center(child: Text("null data"));
        }    
      }
    );
  }
}