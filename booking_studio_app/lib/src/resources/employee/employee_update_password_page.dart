import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../../models/employee/employee_profile.model.dart';
import '../shares/dialog.dart';

class EmployeeUpdatePasswordPage extends StatefulWidget {
  const EmployeeUpdatePasswordPage({Key? key, required this.user, required this.accountId}) : super(key: key);
  final AuthModel user;
  final String accountId;
  // final EmployeeProfileModel employeeProfile;
  @override
  State<EmployeeUpdatePasswordPage> createState() => _EmployeeUpdatePasswordPageState();
}

class _EmployeeUpdatePasswordPageState extends State<EmployeeUpdatePasswordPage> {
  bool _isLoading = false;
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _currentPasswordController = new TextEditingController();
  final TextEditingController _newPasswordController = new TextEditingController();
  final TextEditingController _confirmNewPasswordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // print(widget.employeeProfile.fullname.split(' ').sublist(1).join(' ').trim());
    setState(() {
      var username = widget.user.username;
      _usernameController.text = username != null ? username : "";
    });
  }

  clkOnCancel() {
     Navigator.of(context).pop();
  }

  clkOnChangePassword() async {
    print("clkOnSaveProfile");
    var baseURL = beEnvUrl;
    var url = baseURL + "/identity/updatePassword";
    var username= _usernameController.text;
    var currentPassword = _currentPasswordController.text;
    var newPassword = _newPasswordController.text;
    var confirmNewPassword = _confirmNewPasswordController.text;
    if (username.isNotEmpty && currentPassword.isNotEmpty && newPassword.isNotEmpty && confirmNewPassword.isNotEmpty) {
      var body = jsonEncode({
        "username": username,
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmNewPassword": confirmNewPassword
      });
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: body);
      var result = jsonDecode(response.body);
      print(result['message']);
      if (response.statusCode == 200) {
        print(response.statusCode);
        showMessageBackEmployeeAccountPage(context, "Message", result['message']);
      } else {
        showMessageWithOk(context, "Message", result['message']);
        print(response.statusCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerChild(context, titleText: "Change Password"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
                children: [
                  SizedBox(height: 30),
                  TextField(
                    enabled: false,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    obscureText: true,
                    controller: _currentPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    obscureText: true,
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    obscureText: true,
                    controller: _confirmNewPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                  ),
                  _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(primary),
                        )
                      : SizedBox.shrink(),
                  Gap(50),
                  Row(
                  children: [
                    Container(
                      width: 160,
                      child: GestureDetector(
                        onTap: clkOnCancel,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          decoration: BoxDecoration(
                              border: Border.all(color: primary),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Gap(30),
                    Container(
                      width: 160,
                      child: GestureDetector(
                        onTap: clkOnChangePassword,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Change Password",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                ],
              ),
      ),
    );
  }
}