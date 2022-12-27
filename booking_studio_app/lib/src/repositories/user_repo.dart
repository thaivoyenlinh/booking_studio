
import 'dart:convert';
import 'package:booking_app/src/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class UserRepository{
  String endpoint = 'https://localhost:5001/employee/pagination?CurrentPage=1&RowsPerPage=20';
  Future<List<UserModel>> getUsers() async {
    Response response = await get(Uri.parse(endpoint));
    if(response.statusCode == 200) {
      final List result = jsonDecode(response.body)['rows'];
      return result.map(((e) => UserModel.fromJson(e))).toList();
    }else {
      throw Exception(response.reasonPhrase);
    }
  }
}