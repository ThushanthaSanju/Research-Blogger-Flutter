import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String? id;
  String? image;
  String? imagePath;
  String description;
  String uid;
  bool? isRead = false;

  Article(
      {this.id,
      required this.description,
      this.image,
      this.imagePath,
      required this.uid,
      this.isRead});

  Article.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        image = doc.data()!["image"],
        imagePath = doc.data()!["imagePath"],
        description = doc.data()!["description"],
        uid = doc.data()!["uid"],
        isRead = doc.data()!["isRead"];

  Map<String, dynamic> toJson() => {
        "description": description,
        "image": image,
        "imagePath": imagePath,
        "uid": uid,
        "isRead": isRead,
      };
}
