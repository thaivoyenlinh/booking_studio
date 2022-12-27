import 'package:booking_app/src/resources/employee/employee_account_page.dart';
import 'package:booking_app/src/resources/employee/employee_home_page.dart';
import 'package:booking_app/src/resources/employee/employee_notifycation_page.dart';
import 'package:flutter/material.dart';
import '../../models/auth_model.dart';
import '../../models/employee/employee_profile.model.dart';

class EmployeeBottomNavigationBar extends StatefulWidget {
  const EmployeeBottomNavigationBar({Key? key, required this.user, required this.employee}) : super(key: key);
  final AuthModel user;
  final EmployeeProfileModel employee;
  @override
  State<EmployeeBottomNavigationBar> createState() => _EmployeeBottomNavigationBarState();
}

class _EmployeeBottomNavigationBarState extends State<EmployeeBottomNavigationBar> {
  GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

  int _selectedIndex = 0;
  late final List _pageOptions;
  @override
  void initState() {
    super.initState();
    _pageOptions = [
      EmployeeHomePage(user: widget.user,),
      EmployeeNotifycationPage(user: widget.user, employeeId: widget.employee.id,),
      EmployeeAccountPage(user: widget.user),
      // EmployeeProfilePage()
    ];
  }

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: _pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active_outlined), label: "Notify"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Person")
        ],
      )
    );
  }
}