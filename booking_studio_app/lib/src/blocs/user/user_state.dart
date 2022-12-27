import 'package:booking_app/src/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class UserState extends Equatable {}

class UserLoadingState extends UserState {
  @override 
  List<Object?> get props => [];
}

class UserLoadedState extends UserState {
  UserLoadedState(this.users);
  final List<UserModel> users;

  @override 
  List<Object?> get props => [users];
}

class UserErrorState extends UserState {
  UserErrorState(this.error);
  final String error;

  @override 
  List<Object?> get props => [error];
}
