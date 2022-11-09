import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:research_blogger/models/idea.dart';
import 'package:research_blogger/models/rate.dart';
import 'package:research_blogger/service/ideaService.dart';
import 'package:research_blogger/service/ratingService.dart';

import '../models/arguments.dart';
import '../utils/colorUtils.dart';
import '../widgets/Button.dart';
import '../widgets/TextField.dart';

class AddComment extends StatefulWidget {
  final AddCommentArguments arguments;

  const AddComment({Key? key, required this.arguments}) : super(key: key);

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  // controllers
  final TextEditingController _commentController = TextEditingController();

  double starCount = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add a Comment",
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
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: reusableProfileTextField("Comment", Icons.message,
                      false, _commentController, TextInputType.emailAddress),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: RatingBar.builder(itemBuilder: (context, index) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  }, onRatingUpdate: (rating) {
                    setState(() {
                      starCount = rating;
                    });
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : reusableButton(context, "Save", () async {
                          setState(() {
                            isLoading = true;
                          });
                          var relatedPost =
                              widget.arguments.collection == "ideas"
                                  ? widget.arguments.idea?.id
                                  : widget.arguments.collection == "researches"
                                      ? widget.arguments.research?.id
                                      : widget.arguments.article?.id;

                          var rateObj = Rate(
                              comment: _commentController.text,
                              uid: FirebaseAuth.instance.currentUser?.uid,
                              rate: starCount,
                              relatedPost: relatedPost as String);
                          var response = await RatingService.create(rateObj);

                          if (response.status == 201) {
                            rateObj.id = response.data as String;
                            setState(() {
                              isLoading = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response.message as String),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                            ));
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(response.message as String),
                              backgroundColor: Colors.redAccent,
                              duration: const Duration(seconds: 3),
                            ));
                          }
                        }, null, null),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
