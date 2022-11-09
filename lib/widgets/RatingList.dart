import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_blogger/service/ratingService.dart';

import '../constants.dart';
import '../models/rate.dart';

StreamBuilder<QuerySnapshot<Object?>> reusableCommentSectionList(
    String relatedPostId) {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _collectionReference =
      _firestore.collection("ratings");

  final Stream<QuerySnapshot> _comments = _collectionReference
      .where("relatedPost", isEqualTo: relatedPostId)
      .snapshots();

  return StreamBuilder<QuerySnapshot>(
    stream: _comments,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          var data = Rate.fromDocumentSnapshot(
              document as DocumentSnapshot<Map<String, dynamic>>);

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.comment as String),
                    Text('${data.rate}'),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}

StreamBuilder<QuerySnapshot<Object?>> reusableMyCommentList() {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _collectionReference =
      _firestore.collection("ratings");

  var uid = FirebaseAuth.instance.currentUser?.uid;

  final Stream<QuerySnapshot> _comments =
      _collectionReference.where("uid", isEqualTo: uid).snapshots();

  return StreamBuilder<QuerySnapshot>(
    stream: _comments,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          var data = Rate.fromDocumentSnapshot(
              document as DocumentSnapshot<Map<String, dynamic>>);

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data.comment as String),
                        Text('${data.rate}'),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, UPDATE_COMMENT,
                                arguments: data);
                          },
                          child: const Text("Edit"),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              var response = await RatingService.delete(data.id as String);

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

                            }, child: const Text("Delete")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}
