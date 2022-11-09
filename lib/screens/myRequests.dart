import 'package:flutter/material.dart';
import 'package:research_blogger/service/requestService.dart';

import '../utils/colorUtils.dart';
import '../widgets/RequestList.dart';

class MyRequests extends StatefulWidget {
  final bool myRequest;

  const MyRequests({Key? key, required this.myRequest}) : super(key: key);

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Request",
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
        child: deleting ? const Center(child: CircularProgressIndicator(),) : widget.myRequest ? reusableRequestListView(widget.myRequest, (String id) async {
          setState(() {
            deleting = true;
          });

          await RequestService.delete(id);

          setState(() {
            deleting = false;
          });
        }): reusableReceivedRequestListView(),
      ),
    );
  }
}
