import 'dart:convert';
import 'dart:io';
import 'package:booking_app/src/models/customer/profile.model.dart';
import 'package:booking_app/src/resources/customer/account_page.dart';
import 'package:booking_app/src/resources/shares/dialog.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:booking_app/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../environment.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(
      {Key? key, required this.accountId, required this.customerProfile})
      : super(key: key);
  final String accountId;
  final ProfileModel? customerProfile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullnameController = new TextEditingController();
  final TextEditingController _addressController = new TextEditingController();
  final TextEditingController _phoneNumberController = new TextEditingController();
  // late String? _fullname = "";
  late String? _address = "";
  late String? _phoneNumber = "";
  late String _pathProfileImage = "";
  // late File image;
  var image = File('');
  late String _imagePickerdType = "";
  String url = beEnvUrl + '/Images/Customers/';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  displayProfileImage() {
    if (image != null) {
      if (widget.customerProfile!.image != null) {
        var linkImage = widget.customerProfile!.image;
        print("linkImage");
        print(linkImage);
        if (linkImage != null) {
          return NetworkImage(url + linkImage);
        }
      } else {
        print("linkImage1");
        return AssetImage("assets/images/user-profile-default-image.png");
      }
    } else {
      print("linkImage2");
      return FileImage(image);
    }
  }

  clkOnSaveProfile() async {
    var baseURL = beEnvUrl;
    var url = baseURL + "/customer/update";
    var fullname = _fullnameController.text;
    var address = _addressController.text;
    var phoneNumber = _phoneNumberController.text;
    if (fullname.isNotEmpty && address.isNotEmpty && phoneNumber.isNotEmpty) {
      var body = jsonEncode({
        "id": widget.customerProfile!.id,
        "fullName": fullname,
        "address": address,
        "phoneNumber": phoneNumber
      });
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: body);
      if (response.statusCode == 200) {
        print(response.statusCode);
        var title = "Message";
        var message = "Update is successfully!";
        showMessageBackEmployeeAccountPage(context, "Message", message);
      } else {
        var title = "Message";
        var message = "Update is failure!";
        showMessageBackEmployeeAccountPage(context, "Message", message);
        print(response.statusCode);
      }
    }
  }

  // handleImageFromGallery() async{
  //   try {
  //     final ImagePicker _picker = ImagePicker();
  //     final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
  //     if(imageFile != null){
  //       if(_imagePickerdType == "profile"){
  //         setState(() {
  //           _profileImage = File(imageFile.path);
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  handleImageFromGallery() async {
    print("handleImageFromGallery function");
    var baseURL = beEnvUrl;
    var url = baseURL + "/customer/updateImageAvatar";
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
      print("fileName");
      print(fileName);
      var dioRequest = dio.Dio();
      dioRequest.options.headers = {'Content-Type': 'multipart/form-data'};
      var formData =
          new dio.FormData.fromMap({'id': widget.customerProfile!.id});
      var file =
          await dio.MultipartFile.fromFile(image.path, filename: fileName);
      // contentType: MediaType("image", image.path));
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

  @override
  void initState() {
    super.initState();
    setState(() {
      var fullname = widget.customerProfile?.fullname;
      var address = widget.customerProfile?.address;
      var phoneNumber = widget.customerProfile?.phoneNumber;
      _fullnameController.text = fullname != null ? fullname : "";
      _addressController.text = address != null ? address : "";
      _phoneNumberController.text = phoneNumber != null ? phoneNumber : "";
    });
    print(widget.customerProfile?.phoneNumber);
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
                      controller: _fullnameController,
                      decoration: InputDecoration(
                        labelText: 'Fullname',
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      // initialValue: _phoneNumber,
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
