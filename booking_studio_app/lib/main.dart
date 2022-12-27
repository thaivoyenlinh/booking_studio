import 'dart:io';
import 'package:booking_app/src/blocs/auth/auth_bloc.dart';
import 'package:booking_app/src/blocs/auth/auth_state.dart';
import 'package:booking_app/src/blocs/banner/banner_bloc.dart';
import 'package:booking_app/src/repositories/auth_repo.dart';
import 'package:booking_app/src/repositories/customer/banner_repo.dart';
import 'package:booking_app/src/resources/customer/booking_service_step.dart';
import 'package:booking_app/src/resources/login_page.dart';
import 'package:booking_app/src/resources/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MyHttpOverrides extends HttpOverrides {
@override
HttpClient createHttpClient(SecurityContext? context) {
return super.createHttpClient(context)
  ..badCertificateCallback =
      (X509Certificate cert, String host, int port) => true; }}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthBloc(LoginInitState(), AuthRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/register':(context) => RegisterPage(),  
        },
      ),
    );
  }
}
