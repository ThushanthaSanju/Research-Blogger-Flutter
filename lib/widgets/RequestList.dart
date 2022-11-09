import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:research_blogger/constants.dart';
import 'package:research_blogger/models/requests.dart';

StreamBuilder<QuerySnapshot<Object?>> reusableRequestListView(
    bool? byUser, Function(String id)? delete) {
  var uid = FirebaseAuth.instance.currentUser?.uid;
  final Stream<QuerySnapshot> _stream = byUser == true
      ? FirebaseFirestore.instance
          .collection("requests")
          .where("uid", isEqualTo: uid)
          .snapshots()
      : FirebaseFirestore.instance.collection("requests").snapshots();

  return StreamBuilder<QuerySnapshot>(
    stream: _stream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          var request = Requests.fromDocumentSnapshot(
              document as DocumentSnapshot<Map<String, dynamic>>);

          return Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Title: ${request.title}',
                          style: GoogleFonts.ptSans(
                              fontSize: 20.0, color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Language: ${request.language}',
                          style: GoogleFonts.ptSans(
                              fontSize: 18.0, color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Message: ${request.message}',
                          style: GoogleFonts.ptSans(
                              fontSize: 16.0, color: Colors.black)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, UPDATE_MY_REQUESTS, arguments: request);
                            },
                            child: const Text("Edit"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              delete!(request.id as String);
                            },
                            child: const Text("Delete"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ));
        }).toList(),
      );
    },
  );
}


StreamBuilder<QuerySnapshot<Object?>> reusableReceivedRequestListView() {
  var uid = FirebaseAuth.instance.currentUser?.uid;
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection("requests")
      .where("receiver", isEqualTo: uid)
      .snapshots();

  return StreamBuilder<QuerySnapshot>(
    stream: _stream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          var request = Requests.fromDocumentSnapshot(
              document as DocumentSnapshot<Map<String, dynamic>>);

          return Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Title: ${request.title}',
                          style: GoogleFonts.ptSans(
                              fontSize: 20.0, color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Language: ${request.language}',
                          style: GoogleFonts.ptSans(
                              fontSize: 18.0, color: Colors.black)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Message: ${request.message}',
                          style: GoogleFonts.ptSans(
                              fontSize: 16.0, color: Colors.black)),
                    ),
                  ],
                ),
              ));
        }).toList(),
      );
    },
  );
}
