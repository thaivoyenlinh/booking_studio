import 'dart:convert';
import 'package:booking_app/environment.dart';
import 'package:booking_app/src/models/customer/banner.model.dart';
import 'package:http/http.dart';

class BannerRepository {
  var baseURL = beEnvUrl;

  Future<List<BannerModel>?> getBanners() async {
    try{
      var url = baseURL + "/service/banners";
      Response response = await get(Uri.parse(url));
      if(response.statusCode == 200){
        final List result = jsonDecode(response.body)['rows'];
        return result.map(((e) => BannerModel.fromJson(e))).toList();
      }else{
        print(response.statusCode);
      }
    } catch(e){
      rethrow;
    }
    
  }
}