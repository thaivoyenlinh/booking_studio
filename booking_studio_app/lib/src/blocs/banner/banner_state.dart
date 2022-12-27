import 'package:booking_app/src/models/customer/banner.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class BannerState extends Equatable {}

class BannerInitState extends BannerState{
  @override
  List<Object?> get props => [];
}
 
class BannerLoadingState extends BannerState{
  @override
  List<Object?> get props => [];
}

class BannerLoadedState extends BannerState{
  BannerLoadedState(this.banners);
  final List<BannerModel> banners;

  @override
  List<Object?> get props => [banners];
}

class BannerErrorState extends BannerState{
  BannerErrorState(this.error);
  final String error;
  
  @override
  List<Object?> get props => [];
}