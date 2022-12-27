import 'dart:convert';

import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/employee/employee_add_dayoff_page.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../shares/dialog.dart';

class EmployeeDayOffPage extends StatefulWidget {
  const EmployeeDayOffPage({Key? key, required this.user, required this.employeeId}) : super(key: key);
  final AuthModel user;
  final int employeeId;
  @override
  State<EmployeeDayOffPage> createState() => _EmployeeDayOffPageState();
}

class _EmployeeDayOffPageState extends State<EmployeeDayOffPage> {
  List servicesList = [];
  bool isLoading = false;
  int selectedServiceIndex = -1;
  dynamic serviceIndex = {"id": -1};

  @override
  void initState() {
    super.initState();
    getServices();
  }
  
  getServices() async {
    print("getServices...");
    setState(() {
      isLoading = true;
    });
    var url = beEnvUrl + "/absence/getAbsencesByEmployee?EmployeeId=${widget.employeeId}";
    print(url);
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var services = jsonDecode(response.body);
      setState(() {
        servicesList = services; 
        isLoading = false;
      });
    } else {
      print("getServices... Fail");
      setState(() {
        servicesList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerChild(context, titleText: "Day Off"),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(child: servicesList.length > 0 ? getListServices() : Center(child: Text("Do not have Day Off", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),))),
      ),
      bottomNavigationBar: Container(
              height: 65,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: RaisedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeAddDayOffPage(user: widget.user, employeeId: widget.employeeId)),
                  );
                },
                color: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Create leave application", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),)
                  ],
                ),
              ),
            )
    );
  }

   Widget getListServices(){
    if(servicesList.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator()); 
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: servicesList.length,
      itemBuilder: (context, index){
        Map service = servicesList[index];
      return getCard(service, index);
    });
  }

  Widget getCard(absence, index){
    var status = absence['status'];
    var date = absence['date'];
    print(date);
    var reason = absence['reason'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          tileColor: Color.fromARGB(255, 213, 233, 249),
          title: Row(
            children: [
              SizedBox(width: 20,),
              SizedBox(
                width: 310,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(10),
                    Text(date.toString()),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Reason", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(reason),  
                      ],
                    ),
                    SizedBox(
                          width: 310,
                          child: Divider(color: Colors.amber, thickness: 1.5,)),
                    Gap(7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(status, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                      ],
                    ),               
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
 
}
