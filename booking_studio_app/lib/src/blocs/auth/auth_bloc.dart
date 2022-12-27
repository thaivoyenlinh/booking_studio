import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:booking_app/src/blocs/auth/auth_event.dart';
import 'package:booking_app/src/blocs/auth/auth_state.dart';
import 'package:booking_app/src/repositories/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/validators/login_page_validator.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository _repository;
  final storage = new FlutterSecureStorage();

  AuthBloc(AuthState initialState, this._repository) : super(initialState) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoadingState());
      final data = await _repository.login(event.username, event.password);
      if(data != null ){
        if (data.role == "Employee") {
          await storage.write(key: 'token', value: data.token);
          emit(EmployeeLoginSuccessState(data));
        } else if (data.role == "Customer") {
          await storage.write(key: 'token', value: data.token);
          emit(CustomerLoginSuccessState(data));
        } 
      } else {
        emit(LoginErrorState(message: "Bad Username or Password!"));
      }
    });

    on<RegisterCustomerAccount>((event, emit) async {
      emit(CustomerAccountRegisting());
      await Future.delayed(const Duration(seconds: 3));
      try {
        await _repository.registerCustomerAccount(
            username: event.username,
            password: event.password,
            email: event.email);
        emit(CustomerAccountRegisted());
      } catch (e) {
        emit(CustomerAccountRegistError(e.toString()));
      }
    });
  }
}

class Validate extends Object
    with LoginPageValidators
    implements ValidateLoginPage {
  final _usernameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  StreamSink<String> get usernameChanged => _usernameController.sink;
  StreamSink<String> get passwordChanged => _passwordController.sink;

  Stream<String> get username =>
      _usernameController.stream.transform(usernameValidator);
  Stream<String> get password =>
      _passwordController.stream.transform(passwordValidator);

  Stream<bool> get logInCheck =>
      Rx.combineLatest2(username, password, (u, p) => true);

  @override
  void dispose() {
    _usernameController.close();
    _passwordController.close();
  }
}

abstract class ValidateLoginPage {
  void dispose();
}
