import 'dart:convert';
import 'package:flutter/cupertino.dart';

class BannerModel {
  final int id;
  final String image;

  BannerModel({
    required this.id,
    required this.image
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'], 
      image: json['imageBanner']
    );
  }
  
  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "imageBanner": image == null ? null : image
  };
}