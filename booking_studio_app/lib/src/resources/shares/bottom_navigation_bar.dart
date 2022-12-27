import 'package:booking_app/utils/style.dart';
import 'package:flutter/material.dart';
import '../../models/auth_model.dart';
import '../customer/account_page.dart';
import '../customer/home_page.dart';
import '../customer/message_page.dart';

class BottomNavigationBarUI extends StatefulWidget {
  const BottomNavigationBarUI({Key? key, required this.user}) : super(key: key);
  final AuthModel user;
  @override
  State<BottomNavigationBarUI> createState() => _BottomNavigationBarUIState();
}

class _BottomNavigationBarUIState extends State<BottomNavigationBarUI> {
  int _selectedIndex = 0;
  late final List _pageOptions;
  @override
  void initState() {
    super.initState();
    _pageOptions = [
      HomePage(user: widget.user),
      // MessengerPage(),
      ProfilePage(user: widget.user)
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
          // BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: "Message"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Person")
        ],
      )
    );
  }
}