import 'dart:convert';
import 'dart:io';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/models/employee/employee_profile.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../shares/dialog.dart';
import '../shares/header.dart';

class EmployeeProfilePage extends StatefulWidget {
  const EmployeeProfilePage({Key? key, required this.user, required this.accountId, required this.employeeProfile}) : super(key: key);
  final AuthModel user;
  final String accountId;
  final EmployeeProfileModel employeeProfile;
  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  final TextEditingController _firstNameController = new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _phoneNumberController = new TextEditingController();
  late String _imagePickerdType = "";
  var image = File('');
  String url = beEnvUrl + '/Images/';
  bool _isLoading = false;


  displayProfileImage() {
    if (image != null) {
      if (widget.employeeProfile.image != null) {
        var linkImage = widget.employeeProfile.image;
        if (linkImage != null) {
          return NetworkImage(url + linkImage);
        }
      } else {
        return AssetImage("assets/images/user-profile-default-image.png");
      }
    } else {
      return FileImage(image);
    }
  }

  handleImageFromGallery() async {
    print("handleImageFromGallery function");
    var baseURL = beEnvUrl;
    var url = baseURL + "/employee/updateImageAvatar";
    // late File image;
    var imagePicker =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      setState(() {
        image = File(imagePicker.path);
      });
    }
    try {
      String fileName = image.path.split('/').last;
      var dioRequest = dio.Dio();
      dioRequest.options.headers = {'Content-Type': 'multipart/form-data'};
      var formData =
          new dio.FormData.fromMap({'id': widget.employeeProfile.id});
      var file =
          await dio.MultipartFile.fromFile(image.path, filename: fileName);
      formData.files.add(MapEntry('image', file));
      var response = await dioRequest.post(
        url,
        data: formData,
      );
    } catch (e) {
      print(e);
    }
  }

  clkOnCancel() {
     Navigator.of(context).pop();
  }

  clkOnSaveProfile() async {
    print("clkOnSaveProfile");
    var baseURL = beEnvUrl;
    var url = baseURL + "/employee/update";
    var firstName = _firstNameController.text;
    var lastName = _lastNameController.text;
    var email = _emailController.text;
    var phoneNumber = _phoneNumberController.text;
    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty && phoneNumber.isNotEmpty) {
      var body = jsonEncode({
        "id": widget.employeeProfile.id,
        "badgeId": widget.employeeProfile.badgeId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber
      });
      var response = await http.put(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: body);
      if (response.statusCode == 200) {
        print(response.statusCode);
        var message = "Update is successfully!";
        showMessageBackEmployeeAccountPage(context, "Message", message);
      } else {
        var message = "Update is failure!";
        showMessageBackEmployeeAccountPage(context, "Message", message);
        print(response.statusCode);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // print(widget.employeeProfile.fullname.split(' ').sublist(1).join(' ').trim());
    setState(() {
      var firstName = widget.employeeProfile.fullname.split(' ')[0];
      var lastName = widget.employeeProfile.fullname.split(' ').sublist(1).join(' ').trim();
      var email= widget.employeeProfile.email;
      var phoneNumber = widget.employeeProfile.phoneNumber;
      _firstNameController.text = firstName != null ? firstName : "";
      _lastNameController.text = lastName != null ? lastName : ""; 
      _emailController.text = email != null ? email : "";
      _phoneNumberController.text = phoneNumber != null ? phoneNumber : "";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerChild(context, titleText: "Edit Profile"),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _imagePickerdType = "profile";
                    handleImageFromGallery();
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey,
                        backgroundImage: displayProfileImage(),
                      ),
                      CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.black54,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 25, color: Colors.white),
                              Text(
                                'Change profile photo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 30),
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primary),
                          )
                        : SizedBox.shrink()
                  ],
                ),
                Gap(20),
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
                        onTap: clkOnSaveProfile,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Save",
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
          )
        ],
      ),
    );
  }
}