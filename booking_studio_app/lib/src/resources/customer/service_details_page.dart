import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart' as intl;

import '../../../environment.dart';
import '../../../utils/style.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({Key? key, required this.service}) : super(key: key);
  final Map service;
  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  final formatter = intl.NumberFormat.decimalPattern();
  @override
  Widget build(BuildContext context) {
    List images = widget.service['image'];
    return Scaffold(
      appBar: headerChild(context, titleText: "Details Service"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [ 
          Gap(15),
          Container(
            width: 450,
            height: 350.0,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index){
              return createCard(images[index], index);
            }),
          ),
          Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(20),
              Text(widget.service['serviceName'], style: TextStyle(color: primary, fontSize: 30, fontWeight: FontWeight.bold),),
            ],
          ),
          Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(20),
              Text("Details", style: TextStyle(color: Color.fromARGB(221, 64, 63, 63), fontSize: 25, fontWeight: FontWeight.bold),),
            ],
          ),
          Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(40),
              Text(widget.service['serviceDetails'], style: TextStyle(color: Color.fromARGB(221, 75, 74, 74), fontSize: 20),),
            ],
          ),
          Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(20),
              Text("Price", style: TextStyle(color: Color.fromARGB(221, 64, 63, 63), fontSize: 25, fontWeight: FontWeight.bold),),
              Gap(30),
              Text(formatter.format(widget.service['price']).toString() + " VND", style: TextStyle(color: Colors.red, fontSize: 20),),
            ],
          ),
          Gap(10),
        ]
      ),
    );
  }

  Widget createCard(image, index){
    return Row(
      children: [
        Card(
          elevation: 8,
          shadowColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 450,
            height: 350,
            child: Column(
              children: [
                Image.network(beEnvUrl + "/Images/Services/" + image,
                  width: 450, 
                  height: 330,
                  fit: BoxFit.cover,
                ),
              ],
            ), 
          ),
        ),
        Gap(5)
      ],
    );
  }
}