import 'dart:convert';
import 'package:booking_app/src/models/auth_model.dart';
import 'package:http/http.dart' as http;

import '../../environment.dart';

class AuthRepository {
  
  // var baseURL = "https://localhost:5001";
  var baseURL = beEnvUrl;

  Future<AuthModel?> login(String username, String password) async {
    try {
      var url = baseURL + "/identity/login";
      Map request = {"userName": username, "password": password};
      var body = json.encode(request);
      var response = await http.post(Uri.parse(url),
          headers: {"content-type": "application/json"}, body: body);
      var data = json.decode(response.body);
      if (response.statusCode == 200 && data['role'] == "Employee" ||
          data['role'] == "Customer") {
            print(response.statusCode);
        var tmp = AuthModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        return tmp;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      // print("catch");
      print(e);
      rethrow;
    }
  }

  Future<void> registerCustomerAccount({
      required String username, required String password, required String email}) async {
    try{
      var url = baseURL + "/identity/register";
      var role = "Customer";
      Map data = {
        "userName": username, 
        "password": password,
        "email": email,
        "role": role
      };
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200){
        print(response.statusCode);
      }
    }catch(e) {
      throw Exception(e.toString());
    }
  }

}
