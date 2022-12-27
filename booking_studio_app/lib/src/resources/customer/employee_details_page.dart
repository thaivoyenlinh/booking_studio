import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../shares/header.dart';

class EmployeeDetailsPage extends StatefulWidget {
  const EmployeeDetailsPage({Key? key, required this.employee}) : super(key: key);
  final Map employee;
  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    print("widget.employee");
    print(widget.employee);
    return Scaffold(
      appBar: headerChild(context, titleText: "Details Employee"),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(40),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(color: lightGrey),
                  borderRadius: BorderRadius.circular(60),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(beEnvUrl + "/Images/" + widget.employee['image'])
                )
              ),
            ),
          ),
          Gap(30),
          Row(
            children: [
              Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rating", style: TextStyle(fontSize: 17, color: Color.fromARGB(221, 84, 83, 83)),),
                  Gap(15),
                  Text("Employee Name", style: TextStyle(fontSize: 17, color: Color.fromARGB(221, 84, 83, 83)),),
                  Gap(15),
                  Text("Phone Number", style: TextStyle(fontSize: 17, color: Color.fromARGB(221, 84, 83, 83)),),
                  Gap(15),
                  Text("Email", style: TextStyle(fontSize: 17, color: Color.fromARGB(221, 84, 83, 83)),),
                ],
              ),
              Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(
                    children: [
                      TextSpan(text: widget.employee['rating'].toString(), style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 24)),
                      WidgetSpan(child: Icon(Icons.star_rounded, color: Colors.amber,)),
                    ]
                  )),
                  Gap(15),
                  Text(widget.employee['name'], style: TextStyle(fontSize: 17),),     
                  Gap(15),
                  Text(widget.employee['phone'], style: TextStyle(fontSize: 17),),       
                  Gap(15),
                  Text(widget.employee['email'], style: TextStyle(fontSize: 17),),
                ],
              ), 
              Gap(20)   
            ],
          ), 
        ],
      ),
    );
  }
}