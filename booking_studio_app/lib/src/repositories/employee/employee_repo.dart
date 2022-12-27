import 'dart:convert';
import 'package:booking_app/src/models/employee/employee_profile.model.dart';
import 'package:http/http.dart' as http;
import '../../../environment.dart';

class EmployeeRepository {
  var baseURL = beEnvUrl;

  Future<EmployeeProfileModel?> getEmployeeProfileCurrentUser(String accountId) async {
    try {
      Map request = {"CustomerAccountId": accountId};
      var url = beEnvUrl + "/employee/details?EmployeeAccountId=${accountId}";
      var response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        var tmp = EmployeeProfileModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        return tmp;
      } else {
        print("getEmployeeProfileCurrentUser Get Fail");
        print(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

}
