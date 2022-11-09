import 'package:flutter/material.dart';
import 'package:research_blogger/constants.dart';
import 'package:research_blogger/service/authService.dart';
import 'package:research_blogger/utils/colorUtils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:research_blogger/widgets/AuthOption.dart';
import 'package:research_blogger/widgets/Button.dart';
import 'package:research_blogger/widgets/Logo.dart';
import 'package:research_blogger/widgets/TextField.dart';

import '../models/response.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // controllers
  final TextEditingController _emailNameController = TextEditingController();
  final TextEditingController _passwordNameController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [hexStringToColor("1488cc"), hexStringToColor("2b32b2")],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: [
                reusableLogo("assets/images/logo.png"),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Sign In",
                  style:
                      GoogleFonts.ptSans(fontSize: 22.0, color: Colors.white),
                ),
                const SizedBox(
                  height: 50,
                ),
                reusableTextField("Enter Email", Icons.email_rounded, false,
                    _emailNameController, TextInputType.emailAddress),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock, true,
                    _passwordNameController, TextInputType.visiblePassword),
                const SizedBox(
                  height: 20,
                ),
                loading
                    ? const CircularProgressIndicator()
                    : reusableAuthButton(context, "SIGN IN", () async {
                        var validity = validate(_emailNameController.text,
                            _passwordNameController.text);

                        if (validity.isValid) {
                          setState(() {
                            loading = true;
                          });

                          var response = await AuthService.login(
                              email: _emailNameController.text,
                              password: _passwordNameController.text);

                          if (response.status == 200) {
                            setState(() {
                              loading = true;
                            });
                            Navigator.pushReplacementNamed(context, HOME_SCREEN);
                          }

                          if (response.status == 500) {
                            setState(() {
                              loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response.message as String),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }

                        if (!validity.isValid) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(validity.message),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }),
                const SizedBox(
                  height: 25,
                ),
                authOption("Don't have an account? ", "Sign Up",
                    () => Navigator.pushNamed(context, SIGN_UP_SCREEN)),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Validate validate(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return Validate(isValid: false, message: "All fields are required");
    }

    return Validate(isValid: true, message: "");
  }
}
