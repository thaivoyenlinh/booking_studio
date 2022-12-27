import 'dart:convert';
import 'dart:developer';

import 'package:booking_app/src/models/customer/banner.model.dart';
import 'package:booking_app/src/resources/customer/appointment_page.dart';
import 'package:booking_app/src/resources/customer/booking_service_step.dart';
import 'package:booking_app/src/resources/customer/employee_details_page.dart';
import 'package:booking_app/src/resources/customer/service_details_page.dart';
import 'package:booking_app/src/resources/shares/dialog.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:booking_app/utils/style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/src/repositories/customer/banner_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../blocs/auth/parseJWT.dart';
import '../../models/auth_model.dart';
import '../../models/customer/profile.model.dart';
import '../../repositories/customer/customer.repo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);
  final AuthModel user;

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
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(15),
              AdvertiseBanner(), 
              Gap(10), 
              Categories(user: user),
              Gap(10),
              Row(
                children: [
                  Gap(30),
                  Text("Our Staff", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),),
                ],
              ),
              Gap(10),
              ListEmployee(),
              Gap(10),
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
    print(url);
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
        height: 140.0,
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

class ListEmployee extends StatefulWidget {
  const ListEmployee({
    Key? key,
  }) : super(key: key);

  @override
  State<ListEmployee> createState() => _ListEmployeeState();
}

class _ListEmployeeState extends State<ListEmployee> {
  List employeeList = [];
  bool isLoading = false;

  @override
  void initState() {
    getEmployeeList();
    super.initState();
  }

  getEmployeeList() async {
    print("getEmployeeList...");
    bool scheduleCompleted = false;
    var url = beEnvUrl + "/employee/pagination?SortHeader=2&SortOrder=1&CurrentPage=1&RowsPerPage=100";
    print(url);
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var result = jsonDecode(response.body)['rows'];
      setState(() {
        employeeList = result;
      });
    } else {
      print("getEmployeeList... Fail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        width: double.infinity,
        height: 140.0,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: employeeList.length,
          itemBuilder: (context, index){
            Map employee = employeeList[index];
          return createCard(employee, index);
        }),
      ),
    );
  }

  Widget createCard(employee, index){
    var image = employee['image'];
    var name = employee['name'];
    var rating = employee['rating'];
    // var ratingRounding = rating.toString().substring(0,4);
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EmployeeDetailsPage(employee: employee)));
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
                  Image.network(beEnvUrl + "/Images/" + image,
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
  
  //Check customer full information before booking
  bool clkBookingWithData = true;
  late String accountId = "";
  ProfileModel? customerProfile;
  createAlertDialog(BuildContext context) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    if (token != null) {
      final decode = parseJwt(token);
      setState(() {
        accountId = decode["nameid"];
      });
      ProfileModel? customer = await CustomerRepository().getProfileCurrentUser(accountId);
      setState(() {
        customerProfile = customer;
      });
      if(customer!.fullname == null || customer.address == null || customer.phoneNumber == null){
        setState(() {
          clkBookingWithData = false;
        });
      }
    }
  }

  @override
  void initState() {
    createAlertDialog(context);
    super.initState();
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
            if(clkBookingWithData){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingServicePage(user: widget.user)),
              );
            } else {
              showMessageEditProfile(
                context, 
                "Your personal information is not completed!",
                accountId,
                customerProfile );
            }
            
          },
        ),
        CategoryCard(
          icon: "assets/images/clock.svg",
          text: "Calendar",
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentPage(user: widget.user)),
            );
          },
        ),
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
