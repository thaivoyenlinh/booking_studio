import 'package:booking_app/src/blocs/auth/auth_bloc.dart';
import 'package:booking_app/src/resources/background.dart';
import 'package:booking_app/src/resources/login_page.dart';
import 'package:booking_app/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Background(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is CustomerAccountRegisted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Register success"),
                  duration: Duration(seconds: 2),
                ));
              } else if(state is CustomerAccountRegisting){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Registing"),
                  duration: Duration(seconds: 2),
                ));
              }
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                // BlocBuilder<AuthBloc, AuthState>(
                //   builder: (context, state) {
                //     if (state is CustomerAccountRegisting) {
                //       return Center(child: CircularProgressIndicator());
                //     } else if (state is CustomerAccountRegistError) {
                //       return Center(child: Text("Error"));
                //     }
                //     return LoginPage();
                //   },
                // ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "REGISTER",
                    style: Styles.titlePageStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20.0),
                  child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintStyle: Styles.inputStyle,
                        labelText: "Email",
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintStyle: Styles.inputStyle,
                        labelText: "Username",
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                  child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintStyle: Styles.inputStyle,
                        labelText: "Password",
                      )),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(
                      left: 140, top: 20, right: 30, bottom: 20),
                  child: RaisedButton(
                    onPressed: () async {
                      final String email = _emailController.text;
                      final String username = _usernameController.text;
                      final String password = _passwordController.text;
                      if (email != null &&
                          username != null &&
                          password != null) {
                        clkSignUpButton(context);
                        _emailController.text = '';
                        _usernameController.text = '';
                        _passwordController.text = '';
                        Navigator.of(context).pop();
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      width: size.width * 1.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient:
                              LinearGradient(colors: [orange, orangeLight])),
                      padding: const EdgeInsets.all(0),
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Already have an Account?"),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/");
                          },
                          child:
                              Text(" Sign in", style: Styles.signUpTextStyle))
                    ],
                  ),
                )
              ],
            )),
      ]),
    ));
  }

  void clkSignUpButton(context) {
    authBloc.add(RegisterCustomerAccount(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text));
  }
}
