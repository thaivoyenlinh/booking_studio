import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class BannerEvent extends Equatable {
  const BannerEvent();
}

class LoadBannerEvent extends BannerEvent {
  @override
  List<Object> get props => [];
}