import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:research_blogger/models/requests.dart';
import 'package:research_blogger/models/user.dart';
import 'package:research_blogger/service/authService.dart';
import 'package:research_blogger/service/requestService.dart';
import 'package:research_blogger/service/userService.dart';
import 'package:research_blogger/widgets/TextField.dart';

import '../utils/colorUtils.dart';
import '../widgets/Button.dart';

class AuthorProfile extends StatefulWidget {
  final String id;

  const AuthorProfile({Key? key, required this.id}) : super(key: key);

  @override
  State<AuthorProfile> createState() => _AuthorProfileState();
}

class _AuthorProfileState extends State<AuthorProfile> {
  // controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // objects
  User user = User(uid: "", id: "", userName: "", age: "", email: "");

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    print(widget.id);
    getAuthor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Author Profile",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${user.userName}',
                            style: GoogleFonts.ptSans(
                                fontSize: 18.0, color: Colors.black)),
                        Text('Age: ${user.age}',
                            style: GoogleFonts.ptSans(
                                fontSize: 18.0, color: Colors.black)),
                        Text('Email: ${user.email}',
                            style: GoogleFonts.ptSans(
                                fontSize: 18.0, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text("Request",
                  style: GoogleFonts.ptSans(fontSize: 20.0, color: Colors.black)),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: reusableProfileTextField(
                          "Post Title",
                          Icons.text_fields,
                          false,
                          _titleController,
                          TextInputType.name),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: reusableProfileTextField(
                          "Preferred Language",
                          Icons.language,
                          false,
                          _languageController,
                          TextInputType.name),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: reusableProfileTextField("Message", Icons.message,
                          false, _messageController, TextInputType.name),
                    ),
                    reusableButton(context, isLoading ? "Please wait..." : "Send", sendRequest, null, null),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getAuthor() async {
    var response = await UserService.getUser(widget.id);

    if (response.status == 200) {
      setState(() {
        user = response.data as User;
      });
    }
  }

  sendRequest() async {
    setState(() {
      isLoading = true;
    });


    var response = await RequestService.create(Requests(
        receiver: user.uid as String,
        uid: AuthService.getCurrentUser().data.uid,
        title: _titleController.text,
        language: _languageController.text,
        message: _messageController.text));

    if (response.status == 201) {
      setState(() {
        isLoading = false;
        _titleController.text = "";
        _languageController.text = "";
        _messageController.text = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message as String),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ));
    }

    if (response.status == 500) {
      setState(() {
        isLoading = false;
        _titleController.text = "";
        _languageController.text = "";
        _messageController.text = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message as String),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ));
    }
  }
}
