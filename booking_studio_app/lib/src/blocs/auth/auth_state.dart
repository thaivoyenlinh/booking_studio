import 'package:booking_app/src/models/auth_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitState extends AuthState{}

class LoginLoadingState extends AuthState{}

class CustomerLoginSuccessState extends AuthState{
  CustomerLoginSuccessState(this.users);
  final AuthModel users;

  @override 
  List<Object?> get props => [users];
}

class EmployeeLoginSuccessState extends AuthState{
  EmployeeLoginSuccessState(this.users);
  final AuthModel users;

  @override 
  List<Object?> get props => [users];
}

class LoginErrorState extends AuthState{
  final String message;
  LoginErrorState({required this.message});
}

class InitialState extends AuthState{
  @override
  List<Object?> get props => [];
}

class CustomerAccountRegisting extends AuthState {
  @override
  List<Object?> get props => [];
}

class CustomerAccountRegisted extends AuthState {
  @override
  List<Object?> get props => [];
}

class CustomerAccountRegistError extends AuthState {
  final String error;
  CustomerAccountRegistError(this.error);

  @override
  List<Object?> get props => [error];
}

