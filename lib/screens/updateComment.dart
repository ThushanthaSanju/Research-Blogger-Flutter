import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:research_blogger/models/rate.dart';
import 'package:research_blogger/service/ratingService.dart';
import 'package:research_blogger/widgets/TextField.dart';

import '../utils/colorUtils.dart';
import '../widgets/Button.dart';

class UpdateComment extends StatefulWidget {
  final Rate rate;

  const UpdateComment({Key? key, required this.rate}) : super(key: key);

  @override
  State<UpdateComment> createState() => _UpdateCommentState();
}

class _UpdateCommentState extends State<UpdateComment> {
  // controller
  final TextEditingController _commentController = TextEditingController();

  double starCount = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    starCount = widget.rate.rate!;
    _commentController.text = widget.rate.comment!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Comments",
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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableProfileTextField("Comment", Icons.comment_sharp,
                  false, _commentController, TextInputType.text),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RatingBar.builder(
                  initialRating: starCount,
                  itemBuilder: (context, index) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  },
                  onRatingUpdate: (rating) {
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
              child: loading ? const CircularProgressIndicator() : reusableButton(context, "Update", () async {
                setState(() {
                  loading = true;
                });

                var response = await RatingService.update(Rate(
                    relatedPost: widget.rate.relatedPost,
                    id: widget.rate.id,
                    uid: widget.rate.uid,
                    rate: starCount,
                    comment: _commentController.text));

                if (response.status == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(response.message as String),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ));
                }

                if (response.status == 500) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(response.message as String),
                    backgroundColor: Colors.redAccent,
                    duration: const Duration(seconds: 3),
                  ));
                }

                setState(() {
                  loading = false;
                });
              }, null, null),
            ),
          ],
        ),
      ),
    );
  }
}
