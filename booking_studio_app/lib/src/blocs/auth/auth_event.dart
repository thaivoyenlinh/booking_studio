import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends AuthEvent {}

class LoginButtonPressed extends AuthEvent {
  final String username;
  final String password;
  LoginButtonPressed({required this.username, required this.password});
}

class RegisterCustomerAccount extends AuthEvent {
  final String username;
  final String password;
  final String email;
  
  RegisterCustomerAccount({required this.username, required this.password, required this.email});
}
