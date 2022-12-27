import 'dart:convert';
import 'package:booking_app/src/models/customer/profile.model.dart';
import 'package:http/http.dart';
import '../../../environment.dart';

class CustomerRepository {
  var baseURL = beEnvUrl;

  Future<ProfileModel?> getProfileCurrentUser(String accountId) async {
    try {
      Map request = {"CustomerAccountId": accountId};
      var url = baseURL + "/customer/details?CustomerAccountId=${accountId}";
      Response response = await post(Uri.parse(url));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print("result");
        print(result);
        var tmp = ProfileModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        return tmp;
      } else {
        print("getProfileCurrentUser Get Fail");
        print(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

}
