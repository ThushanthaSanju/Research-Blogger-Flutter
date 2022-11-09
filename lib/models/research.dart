import 'package:cloud_firestore/cloud_firestore.dart';

class Research {
  String? id;
  String category;
  String description;
  String uid;
  bool? isRead = false;

  Research({this.id, required this.category, required this.description, required this.uid, this.isRead});

  Research.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        category = doc.data()!["category"],
        description = doc.data()!["description"],
        uid = doc.data()!["uid"],
        isRead = doc.data()!["isRead"];

  Map<String, dynamic> toJson() => {
        "category": category,
        "description": description,
        "uid": uid,
        "isRead": isRead,
      };
}
