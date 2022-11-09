import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:research_blogger/constants.dart';
import 'package:research_blogger/models/response.dart';
import 'package:research_blogger/models/user.dart';
import 'package:research_blogger/service/authService.dart';
import 'package:research_blogger/service/userService.dart';

import '../utils/colorUtils.dart';
import '../widgets/AuthOption.dart';
import '../widgets/Button.dart';
import '../widgets/Logo.dart';
import '../widgets/TextField.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // controllers
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
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
                  "Sign Up",
                  style:
                      GoogleFonts.ptSans(fontSize: 22.0, color: Colors.white),
                ),
                const SizedBox(
                  height: 50,
                ),
                reusableTextField("Enter Username", Icons.verified_user, false,
                    _userNameController, TextInputType.name),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.email_rounded, false,
                    _emailController, TextInputType.emailAddress),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Age", Icons.timelapse, false,
                    _ageController, TextInputType.text),
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
                    : reusableAuthButton(context, "SIGN UP", () async {
                        var validity = validate(
                            _emailController.text,
                            _userNameController.text,
                            _ageController.text,
                            _passwordNameController.text);

                        if (!validity.isValid) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(validity.message),
                            backgroundColor: Colors.redAccent,
                          ));
                        }

                        if (validity.isValid) {
                          setState(() {
                            loading = true;
                          });
                          var response = await AuthService.register(
                              email: _emailController.text,
                              password: _passwordNameController.text);


                          if (response.status == 201) {
                            var res = await UserService.create(User(
                                uid: response.data.uid,
                                userName: _userNameController.text,
                                email: _emailController.text,
                                age: _ageController.text));

                            print(res.status);

                            if (res.status == 201) {
                              setState(() {
                                loading = false;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(response.message as String),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ));

                              Navigator.pushNamed(context, SIGN_IN_SCREEN);
                            }

                            if (res.status == 500) {
                              setState(() {
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(response.message as String),
                                backgroundColor: Colors.redAccent,
                              ));
                            }
                          }

                          if (response.status == 500) {
                            setState(() {
                              loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response.message as String),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        }
                      }),
                const SizedBox(
                  height: 25,
                ),
                authOption("Already have an account? ", "Sign In",
                    () => Navigator.pushNamed(context, SIGN_IN_SCREEN)),
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

  Validate validate(
      String email, String userName, String age, String password) {
    if (email.isEmpty || password.isEmpty || userName.isEmpty || age.isEmpty) {
      return Validate(isValid: false, message: "All fields are required");
    }

    return Validate(isValid: true, message: "");
  }
}
