import 'package:booking_app/src/resources/customer/home_page.dart';
import 'package:booking_app/src/resources/login_page.dart';
import 'package:booking_app/src/resources/shares/bottom_navigation_bar.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/auth_model.dart';

class HomeCustomerPage extends StatefulWidget {
  const HomeCustomerPage({Key? key, required this.user}) : super(key: key);
  final AuthModel user;

  @override
  State<HomeCustomerPage> createState() => _HomeCustomerPageState();
}

class _HomeCustomerPageState extends State<HomeCustomerPage> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async{
    // check if token is there
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if(token!= null){
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: HomePage(),
      body: this._isLoggedIn ? HomePage(user: widget.user) : LoginPage(),
      bottomNavigationBar: BottomNavigationBarUI(user: widget.user)
    );
  }
}




// import 'dart:convert';

// import 'package:booking_app/src/resources/customer/home_page.dart';
// import 'package:booking_app/src/resources/login_page.dart';
// import 'package:booking_app/src/resources/shares/bottom_navigation_bar.dart';
// import 'package:booking_app/src/resources/shares/header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;

// import '../../../environment.dart';
// import '../../blocs/auth/parseJWT.dart';
// import '../../models/auth_model.dart';
// import '../../models/customer/profile.model.dart';

// class HomeCustomerPage extends StatefulWidget {
//   const HomeCustomerPage({Key? key, required this.user}) : super(key: key);
//   final AuthModel user;

//   @override
//   State<HomeCustomerPage> createState() => _HomeCustomerPageState();
// }

// class _HomeCustomerPageState extends State<HomeCustomerPage> {
//   bool _isLoggedIn = false;

//   @override
//   void initState() {
//     _checkIfLoggedIn();
//     super.initState();
//   }

//   void _checkIfLoggedIn() async{
//     // check if token is there
//     final storage = new FlutterSecureStorage();
//     var token = await storage.read(key: 'token');
//     if(token!= null){
//       setState(() {
//         _isLoggedIn = true;
//       });
//     }
//   }

//   Future<ProfileModel> _getDetailsCustomer() async {
//     print("_getDetailsCustomer...");
//     String accountIdtmp = "";
//     final storage = new FlutterSecureStorage();
//     var token = await storage.read(key: 'token');
//     if (token != null) {
//       final decode = parseJwt(token);
//       accountIdtmp = decode["nameid"];
//     }
//     var url = beEnvUrl + "/customer/details?CustomerAccountId=${accountIdtmp}";
//     var response = await http.post(Uri.parse(url));
//     return ProfileModel.fromJson(
//             jsonDecode(response.body) as Map<String, dynamic>);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ProfileModel>(
//       future: _getDetailsCustomer(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//             var customer = snapshot.data as ProfileModel;
//             return Scaffold(         
//               body: this._isLoggedIn ? HomePage(user: widget.user) : LoginPage(),
//               bottomNavigationBar: BottomNavigationBarUI(user: widget.user, customer: customer,)
//           );
//         } else if(snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else {
//             return Center(child: Text("null data"));
//         }    
//       }
//     );
//   }
// }