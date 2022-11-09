import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:research_blogger/models/rate.dart';

class Idea {
  String? id;
  String description;
  String uid;
  bool? isRead = false;

  Idea({this.id, required this.description, required this.uid, this.isRead});

  Idea.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        description = doc.data()!["description"],
        uid = doc.data()!["uid"],
        isRead = doc.data()!["isRead"];

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "isRead": isRead,
      };
}
