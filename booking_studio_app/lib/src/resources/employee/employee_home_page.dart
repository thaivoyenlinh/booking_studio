import 'dart:convert';

import 'package:booking_app/src/resources/employee/employee_appointment_page.dart';
import 'package:booking_app/src/resources/employee/employee_dayoff_page.dart';
import 'package:booking_app/src/resources/employee/employee_schedule_plan_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';
import '../../blocs/auth/parseJWT.dart';
import '../../models/auth_model.dart';
import '../../models/customer/banner.model.dart';
import '../../models/employee/employee_profile.model.dart';
import '../../repositories/customer/banner_repo.dart';
import '../customer/service_details_page.dart';
import '../shares/header.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({Key? key, required this.user}) : super(key: key);
  final AuthModel user;
  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: header(context, isAppTitle: true),
          ),
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              Gap(30),
              AdvertiseBanner(), 
              Gap(20), 
              Categories(user: widget.user),
              Gap(20),
              Row(
                children: [
                  Gap(30),
                  Text("Our Service", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),),
                ],
              ),
              Gap(10),
              ListService()
            ],
          )),
    );
  }
}

class ListService extends StatefulWidget {
  const ListService({
    Key? key,
  }) : super(key: key);

  @override
  State<ListService> createState() => _ListServiceState();
}

class _ListServiceState extends State<ListService> {
  List serviceList = [];
  bool isLoading = false;

  @override
  void initState() {
    getServiceList();
    super.initState();
  }

  getServiceList() async {
    print("getServiceList...");
    bool scheduleCompleted = false;
    var url = beEnvUrl + "/service/pagination?SortHeader=1&SortOrder=1&CurrentPage=1&RowsPerPage=100";
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var result = jsonDecode(response.body)['rows'];
      setState(() {
        serviceList = result;
      });
    } else {
      print("getServiceList... Fail");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        width: double.infinity,
        height: 150.0,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: serviceList.length,
          itemBuilder: (context, index){
            Map employee = serviceList[index];
          return createCard(employee, index);
        }),
      ),
    );
  }

  Widget createCard(service, index){
    var image = service['banner'];
    var name = service['serviceName'];
    var rating = service['rating'];
    // var ratingRounding = rating.toString().substring(0,4);
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ServiceDetailsPage(service: service)));
          },
          child: Card(
            elevation: 8,
            shadowColor: primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 150,
              height: 130,
              child: Column(
                children: [
                  Image.network(beEnvUrl + "/Images/Services/" + image,
                    width: double.infinity, 
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Gap(5),
                      Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),),
                      Text.rich(TextSpan(
                        children: [
                          TextSpan(text: rating.toString() != null ? rating.toString() : 0.toString(), style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                          WidgetSpan(child: Icon(Icons.star_rounded, color: Colors.amber,)),
                        ]
                      ))
                    ],
                  ),
                ],
              ), 
            ),
          ),
        ),
        Gap(5)
      ],
    );
  }
}

class AdvertiseBanner extends StatelessWidget {
  const AdvertiseBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BannerRepository().getBanners(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var banners = snapshot.data! as List<BannerModel>;
          var url = "https://10.0.2.2:5001/Images/Services/";
          return CarouselSlider(
            options: CarouselOptions(
                enlargeCenterPage: true,
                aspectRatio: 3.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3)),
            items: banners
                .map((e) => Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Image.network(
                          url + e.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ))
                .toList(),
          );
        }
      },
    );
  }
}

class Categories extends StatefulWidget {
  const Categories({Key? key, required this.user}) : super(key: key);
  final AuthModel user;
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  @override
  void initState() {
    super.initState();
  }

  Future<EmployeeProfileModel> _getDetailsEmployee() async {
    print("_getDetailsEmployee...");
    String accountIdtmp = "";
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if (token != null) {
      final decode = parseJwt(token);
      accountIdtmp = decode["nameid"];
    }
    var url = beEnvUrl + "/employee/details?EmployeeAccountId=${accountIdtmp}";
    var response = await http.post(Uri.parse(url));
    return EmployeeProfileModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryCard(
          icon: "assets/images/booking.svg",
          text: "Booking",
          press: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeAppointmentPage(user: widget.user)),
              );
          },
        ),
        FutureBuilder(
                future: _getDetailsEmployee(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text(""));
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    var employee = snapshot.data! as EmployeeProfileModel;
                    return CategoryCard(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeSchedulePlanPage(
                                  user: widget.user,
                                  employeeId: employee.id,
                          )),
                        );
                      },
                      icon: "assets/images/appointment.svg",
                      text: "Schedule",
                    );
                  } else {
                    return Center(child: Text("null data"));
                  }
                }),
        FutureBuilder(
                future: _getDetailsEmployee(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text(""));
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    var employee = snapshot.data! as EmployeeProfileModel;
                    return CategoryCard(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeDayOffPage(
                                  user: widget.user,
                                  employeeId: employee.id,
                          )),
                        );
                      },
                      icon: "assets/images/dayoff.svg",
                      text: "Day Off",
                    );
                  } else {
                    return Center(child: Text("null data"));
                  }
                }),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: profileFlatButtonColor,
                    borderRadius: BorderRadius.circular(10)),
                child: SvgPicture.asset(
                  icon,
                  color: primary,
                  fit: BoxFit.cover
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: inputColor),
            )
          ],
        ),
      ),
    );
  }
}