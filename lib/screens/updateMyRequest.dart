import 'package:flutter/material.dart';
import 'package:research_blogger/models/requests.dart';
import 'package:research_blogger/service/requestService.dart';

import '../utils/colorUtils.dart';
import '../widgets/Button.dart';
import '../widgets/TextField.dart';

class UpdateMyRequest extends StatefulWidget {
  final Requests requests;

  const UpdateMyRequest({Key? key, required this.requests}) : super(key: key);

  @override
  State<UpdateMyRequest> createState() => _UpdateMyRequestState();
}

class _UpdateMyRequestState extends State<UpdateMyRequest> {
  // controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.requests.title;
    _languageController.text = widget.requests.language;
    _messageController.text = widget.requests.message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Request",
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 5,
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
                reusableButton(context, isLoading ? "Please wait..." : "Update",
                    update, null, null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  update() async {
    var response = await RequestService.update(Requests(
        uid: widget.requests.uid,
        title: _titleController.text,
        language: _languageController.text,
        message: _messageController.text,
        id: widget.requests.id,
        receiver: widget.requests.receiver));

    if (response.status == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message as String),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message as String),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
