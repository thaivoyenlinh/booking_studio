import 'package:booking_app/utils/style.dart';
import 'package:flutter/material.dart';

AppBar header(context, { bool isAppTitle = false, String titleText = "" }){
  return AppBar(
    toolbarHeight: 100,
    title: Column(
      children: [
        SizedBox(height: 40,),
        Text(
          isAppTitle ? "Hello Studio" : titleText,
          style: TextStyle(
            color: Colors.white,
            fontFamily: isAppTitle ? "Signatra" : "",
            fontSize: isAppTitle ? 40 : 20
          ),
        ),
      ],
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Colors.pink, Colors.purple, Color.fromARGB(255, 37, 125, 197)]),
      ),
    ),
    centerTitle: true,
    // backgroundColor: primary,
    // automaticallyImplyLeading: isAppTitle ? false : true,
    automaticallyImplyLeading: false,
  );
}

AppBar headerChild(context, { bool isAppTitle = false, String titleText = "" }){
  return AppBar(
    toolbarHeight: 70,
    title: Column(
      children: [
        // SizedBox(height: 70,),
        Text(
          isAppTitle ? "Hello Studio" : titleText,
          style: TextStyle(
            color: Colors.white,
            fontFamily: isAppTitle ? "Signatra" : "",
            fontSize: isAppTitle ? 40 : 20
          ),
        ),
      ],
    ),
    centerTitle: true,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Colors.pink, Colors.purple, Color.fromARGB(255, 37, 125, 197)]),
      ),
    ),
    // automaticallyImplyLeading: isAppTitle ? false : true,
    // automaticallyImplyLeading: true,
  );
}