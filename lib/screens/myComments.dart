import 'package:flutter/material.dart';

import '../utils/colorUtils.dart';
import '../widgets/RatingList.dart';

class MyComments extends StatefulWidget {
  const MyComments({Key? key}) : super(key: key);

  @override
  State<MyComments> createState() => _MyCommentsState();
}

class _MyCommentsState extends State<MyComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Comments",
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
      body: Column(
        children: [
          Expanded(
            child: reusableMyCommentList(),
          ),
        ],
      ),
    );
  }
}
