import 'package:flutter/material.dart';

import '../utils/colorUtils.dart';
import '../widgets/RequestList.dart';

class ReceivedRequest extends StatefulWidget {
  const ReceivedRequest({Key? key}) : super(key: key);

  @override
  State<ReceivedRequest> createState() => _ReceivedRequestState();
}

class _ReceivedRequestState extends State<ReceivedRequest> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Requests",
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: deleting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : reusableReceivedRequestListView(),
      ),
    );
  }
}
