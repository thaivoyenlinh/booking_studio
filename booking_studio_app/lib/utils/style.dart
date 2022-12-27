import 'package:flutter/material.dart';

//declare a variable outside a class you can access it from anywhere, suitable for access directly
Color primary = const Color(0xFF687daf);
Color titlePageColor = Color.fromARGB(255, 43, 103, 241);
Color lightBlueBorderColor = Color.fromARGB(255, 95, 143, 181);
Color inputColor = const Color(0xFF666666);
Color lightGrey = Color.fromARGB(255, 179, 175, 175);
Color profileFlatButtonColor = Color.fromARGB(255, 219, 226, 226);
Color orange = const Color.fromARGB(255, 255, 136, 34);
Color orangeLight = const Color.fromARGB(255, 255, 177, 41);
Color pinkLight = const Color.fromARGB(255, 247, 196, 213);

//define inside a class as a static, first write the class name and use dot operator to call them.
class Styles {
  static Color primaryColor = primary;
  static Color textColor = const Color(0xFF3b3b3b);
  static Color backGroundColor = const Color(0xFFeeedf2);
  static Color orangeColor = const Color(0xFFF37B67);
  static TextStyle titlePageStyle = TextStyle(fontSize: 24, color: titlePageColor, fontWeight: FontWeight.bold);
  static TextStyle inputStyle = TextStyle(fontSize: 16, color: inputColor);
  static TextStyle signUpTextStyle = TextStyle(color: titlePageColor, fontWeight: FontWeight.bold);
  static TextStyle profileUsernameTextStyle = TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);
  static TextStyle profileEmailTextStyle = TextStyle(fontSize: 14, color: Colors.white);
  static TextStyle headerStepBookingTextStyle = TextStyle(color: lightGrey, fontSize: 22, fontWeight: FontWeight.bold);
}