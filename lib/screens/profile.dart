import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:research_blogger/constants.dart';
import 'package:research_blogger/models/user.dart';
import 'package:research_blogger/service/authService.dart';
import 'package:research_blogger/service/userService.dart';
import 'package:research_blogger/utils/colorUtils.dart';
import 'package:research_blogger/widgets/Button.dart';
import 'package:research_blogger/widgets/TextField.dart';

import '../models/response.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // controllers
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final _firebaseStorage = FirebaseStorage.instance;

  File? image;
  late dynamic currentUser;
  late User user;

  bool isUpdating = false;
  bool isDeleting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentUser = AuthService
        .getCurrentUser()
        .data;
    getUserDetails(currentUser.uid);

    _emailNameController.text = currentUser.email;
  }

  getUserDetails(String uid) async {
    var response = await UserService.getUser(uid);

    setState(() {
      user = response.data;
      _userNameController.text = response.data.userName;
      _ageController.text = response.data.age;
    });
  }

  updateUser(User user) async {
    if (isUpdating == false) {
      setState(() {
        isUpdating = true;
      });
    }

    return await UserService.updateUser(user);
  }

  updateAuth() async {
    if (isUpdating == false) {
      setState(() {
        isUpdating = true;
      });
    }
    await currentUser?.updateEmail(_emailNameController.text);
  }

  deleteAccount() async {
    setState(() {
      isDeleting = true;
    });

    await UserService.deleteUser(user.id!);
    return await AuthService.deleteUser(_passwordController.text);
  }

  Future pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (img == null) return;

      final imgTemp = File(img.path);

      setState(() {
        image = imgTemp;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  hexStringToColor("1488cc"),
                  hexStringToColor("2b32b2")
                ]),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1)),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: image != null
                                  ? FileImage(image!) as ImageProvider
                                  : const NetworkImage(
                                  'https://cdn.pixabay.com/photo/2018/01/29/17/01/woman-3116587_960_720.jpg'))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.white),
                        ),
                        child: GestureDetector(
                            onTap: () {
                              pickImage();
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: reusableProfileTextField(
                    "User Name",
                    Icons.verified_user,
                    false,
                    _userNameController,
                    TextInputType.name),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: reusableProfileTextField("Email", Icons.email_rounded,
                    false, _emailNameController, TextInputType.emailAddress),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: reusableProfileTextField("Age", Icons.timelapse, false,
                    _ageController, TextInputType.number),
              ),
              const SizedBox(
                height: 20,
              ),
              reusableButton(context, isUpdating ? "Please wait.." : "Update",
                      () async {
                    user.userName = _userNameController.text;
                    user.age = _ageController.text;

                    await updateUser(user);
                    await updateAuth();

                    setState(() {
                      isUpdating = false;
                    });
                  }, null, null),
              reusableDeleteButton(
                  context,
                  isDeleting ? "Please wait.." : "Delete",
                      () async {
                    _showDialog();
                  },
                  null,
                  null),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter password"),
            content: SingleChildScrollView(
              child: TextField(controller: _passwordController,),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    Response response = await deleteAccount();

                    if (response.status == 200) {
                      setState(() {
                        isDeleting = false;
                      });

                      Navigator.pushReplacementNamed(context, SIGN_IN_SCREEN);
                    }
                  },
                  child: const Text("Submit"))
            ],
          );
        });
  }
}
