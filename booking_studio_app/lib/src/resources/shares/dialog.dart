import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/models/customer/profile.model.dart';
import 'package:booking_app/src/resources/customer/home_customer_page.dart';
import 'package:booking_app/src/resources/employee/employee_account_page.dart';
import 'package:booking_app/src/resources/employee/employee_home_page.dart';
import 'package:booking_app/utils/style.dart';
import 'package:flutter/material.dart';

import '../customer/appointment_page.dart';
import '../customer/appointment_schedule_finish.dart';
import '../customer/profile_customer_page.dart';

showMessageWithOk(BuildContext context, String title, String contentMessage) {
  Widget okButton = FlatButton(
    child: Text("OK", style: TextStyle(color: primary)),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(contentMessage),
    actions: [okButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

showMessageWithYesNo(
    BuildContext context, String title, String contentMessage) {
  Widget yesButton = FlatButton(
    child: Text("YES", style: TextStyle(color: primary)),
    onPressed: () {
      Navigator.pushNamed(context, '/');
    },
  );

  Widget noButton = FlatButton(
    child: Text("NO", style: TextStyle(color: primary)),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(contentMessage),
    actions: [yesButton, noButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

showMessageEditProfile(BuildContext context, String contentMessage,
    String accountId, ProfileModel? customer) {
  Widget okButton = FlatButton(
    child: Text("OK", style: TextStyle(color: primary)),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfilePage(
                  accountId: accountId,
                  customerProfile: customer,
                )),
      );
    },
  );

  AlertDialog alertDialog = AlertDialog(
    content: Text(contentMessage),
    actions: [okButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.of(context).pop(true);
        });
        return alertDialog;
      });
}

showMessageWithOkNavigateHomePage(BuildContext context, String title, String contentMessage, AuthModel user) {
  Widget okButton = FlatButton(
    child: Text("OK", style: TextStyle(color: primary)),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeCustomerPage(user: user,)),
      );
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(contentMessage),
    actions: [okButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

showMessageOkRatingPage(BuildContext context, String title, String contentMessage, AuthModel user) {
  Widget okButton = FlatButton(
    child: Text("OK", style: TextStyle(color: primary)),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AppointmentPage(user: user)),
      );
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(contentMessage),
    actions: [okButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

showMessageBackEmployeeAccountPage(BuildContext context, String title, String contentMessage) {
  Widget okButton = FlatButton(
    child: Text("OK", style: TextStyle(color: primary)),
    onPressed: () {
      var nav = Navigator.of(context);
        nav.pop();
        nav.pop();
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(contentMessage),
    actions: [okButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

showMessageWithOkNavigateEmployeeHomePage(BuildContext context, String title, String contentMessage, AuthModel user) {
  Widget okButton = FlatButton(
    child: Text("OK", style: TextStyle(color: primary)),
    onPressed: () {
      var nav = Navigator.of(context);
        nav.pop();
        nav.pop();
        nav.pop();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => EmployeeHomePage(user: user,)),
      // );
    },
  );

  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(contentMessage),
    actions: [okButton],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}