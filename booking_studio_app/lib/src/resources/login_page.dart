import 'package:booking_app/src/blocs/auth/auth_bloc.dart';
import 'package:booking_app/src/blocs/auth/auth_event.dart';
import 'package:booking_app/src/blocs/auth/auth_state.dart';
import 'package:booking_app/src/models/auth_model.dart';
import 'package:booking_app/src/resources/background.dart';
import 'package:booking_app/src/resources/customer/home_customer_page.dart';
import 'package:booking_app/src/resources/shares/dialog.dart';
import 'package:booking_app/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'employee/home_employee_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkUsername = false;
  late AuthBloc authBloc;

  final validate = Validate();

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final pageTitle = Text("HELLO STUDIO", style: TextStyle(fontSize: 50, color: titlePageColor, fontWeight: FontWeight.bold, fontFamily: "Signatra"));

    final signUpText = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text("Don't have an Account?"),
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/register");
            },
            child: Text(" Sign Up", style: Styles.signUpTextStyle))
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is EmployeeLoginSuccessState) {
                AuthModel user = state.users;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeEmployeePage(user: user)));
              } else if (state is CustomerLoginSuccessState) {
                AuthModel user = state.users;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeCustomerPage(user: user)));
              } else if (state is LoginErrorState){
                showMessageWithOk(context, "Message", state.message);
              }
            },
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                children: <Widget>[
                  pageTitle,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: StreamBuilder<String>(
                      stream: validate.username,
                      builder: ((context, snapshot) => TextField(
                            onChanged: (s) => validate.usernameChanged.add(s),
                            controller: usernameController,
                            keyboardType: TextInputType.name,
                            autofocus: false,
                            decoration: InputDecoration(
                                hintStyle: Styles.inputStyle,
                                hintText: "Username",
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: StreamBuilder<String>(
                      stream: validate.password,
                      builder: ((context, snapshot) => TextField(
                            onChanged: (s) => validate.passwordChanged.add(s),
                            controller: passwordController,
                            autofocus: false,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintStyle: Styles.inputStyle,
                                hintText: "Password",
                                errorText: snapshot.hasError
                                    ? snapshot.error.toString()
                                    : null),
                          )),
                    ),
                  ),
                  StreamBuilder<bool>(
                      stream: validate.logInCheck,
                      builder: ((context, snapshot) => Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(left: 120, bottom: 20),
                            child: RaisedButton(
                              onPressed:
                                  snapshot.hasData ? () => clkLogin() : null,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                alignment: Alignment.center,
                                height: 40.0,
                                width: size.width * 1.2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                        colors: [orange, orangeLight])),
                                padding: const EdgeInsets.all(0),
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ))
                          ),
                  signUpText
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  clkLogin() {
    authBloc.add(LoginButtonPressed(
        username: usernameController.text, password: passwordController.text));
  }
}
