import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/shares/dialog.dart';
import 'package:booking_app/src/resources/shares/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../environment.dart';
import '../../../utils/style.dart';

class RatingPage extends StatefulWidget {
  const RatingPage(
      {Key? key, required this.scheduleId, required this.serviceName, required this.user})
      : super(key: key);
  final int scheduleId;
  final String serviceName;
  final AuthModel user;

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double ratingService = 5;
  double ratingEmployee = 5;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerChild(context, titleText: "Rating"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Service",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Gap(20),
                Text(widget.serviceName,
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ],
            ),
            Gap(10),
            Text("Please rating for service quality",
                style: TextStyle(fontSize: 20)),
            Gap(20),
            buildRating("service"),
            Gap(20),
            Text("Please rating for Staff", style: TextStyle(fontSize: 20)),
            Gap(10),
            buildRating("employee"),
            Gap(30),
            Container(
                child: RaisedButton(
              onPressed: ratingEmployee > 0 && ratingService > 0 ? () => clkOnRate(widget.scheduleId) : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    gradient: LinearGradient(
                        colors: ratingEmployee > 0 && ratingService > 0 ? [orange, Colors.red.shade400, Colors.pink] : [Color.fromARGB(255, 219, 215, 215), Color.fromARGB(255, 164, 161, 161), Color.fromARGB(255, 219, 215, 215)]
                        )
                  ),
                child: Container(
                  constraints: const BoxConstraints(
                      minWidth: 88.0,
                      minHeight: 36.0), // min sizes for Material buttons
                  alignment: Alignment.center,
                  child: const Text(
                    'Rate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget buildRating(ratingFor) {
    return RatingBar.builder(
      initialRating: 5,
      minRating: 1,
      itemSize: 40,
      itemPadding: EdgeInsets.symmetric(horizontal: 4),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      updateOnDrag: true,
      onRatingUpdate: (rating) => setState(() {
        if (ratingFor == "service") {
          this.ratingService = rating;
        } else {
          this.ratingEmployee = rating;
        }
      }),
    );
  }

  clkOnRate(schedleId) async{
    print("clkOnRate...");
    setState(() {
      isLoading = true;
    });
    print(ratingEmployee);
    print(ratingService);
    print(schedleId);
    
    var url = beEnvUrl + "/schedule/updateRating?ScheduleId=${schedleId}&EmployeeRating=${ratingEmployee}&ServiceRating=${ratingService}";
    var response = await http.post(Uri.parse(url));
    if(response.statusCode == 200){
      print(200);
      setState(() {
        isLoading = false;
      });
      showMessageOkRatingPage(context, "Message", "We have received your review!", widget.user);
    } else {
      print("clkOnConfirm... Fail");
      setState(() {
        isLoading = false;
      });
      showMessageOkRatingPage(context, "Message", "We haven't received your review yet!", widget.user);
    }
  }
}
