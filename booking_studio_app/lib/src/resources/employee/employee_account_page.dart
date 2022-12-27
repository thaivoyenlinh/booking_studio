import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/models/employee/employee_profile.model.dart';
import 'package:booking_app/src/resources/employee/employee_profile_page.dart';
import 'package:booking_app/src/resources/employee/employee_update_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../../blocs/auth/parseJWT.dart';
import '../../repositories/employee/employee_repo.dart';
import '../shares/dialog.dart';
import '../shares/header.dart';

class EmployeeAccountPage extends StatefulWidget {
  const EmployeeAccountPage({Key? key, required this.user}) : super(key: key);
  final AuthModel user;
  @override
  State<EmployeeAccountPage> createState() => _EmployeeAccountPageState();
}

class _EmployeeAccountPageState extends State<EmployeeAccountPage> {
  late String accountId = "";
  late EmployeeProfileModel employeeProfile;

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  _getToken() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if (token != null) {
      final decode = parseJwt(token);
      setState(() {
        accountId = decode["nameid"];
      });
    }
  }

  _logOut() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'token');
    showMessageWithYesNo(context, 'Log Out', 'See you later!');
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: header(context, titleText: "Profile"),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Column(
          children: [
            ProfilePic(),
            Gap(20),
            FutureBuilder(
                future: EmployeeRepository().getEmployeeProfileCurrentUser(accountId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    var employee = snapshot.data! as EmployeeProfileModel;
                    return ProfileMenu(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeProfilePage(
                                  employeeProfile: employee,
                                  user: widget.user,
                                  accountId: accountId,
                          )),
                        );
                      },
                      icon: "assets/images/UserIcon.svg",
                      text: "My Account",
                    );
                  } else {
                    return Center(child: Text("null data"));
                  }
                }),
            FutureBuilder(
              future: EmployeeRepository().getEmployeeProfileCurrentUser(accountId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text(""));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  var employee = snapshot.data! as EmployeeProfileModel;
                  return ProfileMenu(
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  EmployeeUpdatePasswordPage(
                            // employeeProfile: employee,
                            user: widget.user,
                            accountId: accountId, 
                          )),
                      );
                    },
                    icon: "assets/images/password.svg",
                    text: "Change Password",
                  );
                } else {
                  return Center(child: Text("null data"));
                }
              }
            ),
            ProfileMenu(
              press: _logOut,
              icon: "assets/images/Logout.svg",
              text: "Log Out",
            ),
          ],
        )),
      ),
    );
  }
}

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  late String accountId = "";
  late String username = "";

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  _getToken() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if (token != null) {
      final decode = parseJwt(token);
      setState(() {
        accountId = decode["nameid"];
        username = decode["given_name"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: EmployeeRepository().getEmployeeProfileCurrentUser(accountId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text(""));
            } else if (snapshot.connectionState == ConnectionState.done) {
              var employee = snapshot.data! as EmployeeProfileModel;
              var urlToLoadAvatar = beEnvUrl + '/Images/';
              var imagepath = employee.image;
              var lenght = employee.rating.toString().length;
              // var ratingRounding = employee.rating.toString().substring(0,4);
              return Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.pink,
                        Colors.blue,
                        Colors.orange
                      ]
                    ),
                    // color: Styles.primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(80),
                        bottomLeft: Radius.circular(80))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, right: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        maxRadius: 50.0,
                        minRadius: 50.0,
                        backgroundImage: imagepath == null
                            ? AssetImage('assets/images/img.png')
                            : NetworkImage(urlToLoadAvatar + imagepath)
                                as ImageProvider,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(employee.fullname == null ? username : employee.fullname,
                              style: Styles.profileUsernameTextStyle),
                          Text(employee.email,
                              style: Styles.profileEmailTextStyle),
                          Gap(4),
                          Text(employee.phoneNumber,
                              style: Styles.profileEmailTextStyle),
                          Gap(4),
                          Row(
                            children: [
                              Text("Rating", style: TextStyle(color: Colors.white),),
                              Gap(5),
                              // Text.rich(TextSpan(
                              //   children: [
                              //     TextSpan(text: ratingRounding, style: TextStyle(fontSize: 16,color: Colors.amber, fontWeight: FontWeight.bold)),
                              //     WidgetSpan(child: Icon(Icons.star_rounded, color: Colors.amber,)),
                              //   ]
                              // ))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: Text("null data"));
            }
          }),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.press,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final VoidCallback press;
  final String icon, text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: profileFlatButtonColor,
        onPressed: press,
        child: Row(
          children: [
            Gap(10),
            SvgPicture.asset(icon, width: 22, color: primary),
            SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            )),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
