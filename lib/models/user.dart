import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? uid;
  String? userName;
  String email;
  String? age;

  User({this.id, this.uid, this.userName, required this.email, this.age});

  User.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        uid = doc.data()!["uid"],
        userName = doc.data()!["userName"],
        email = doc.data()!["email"],
        age = doc.data()!["age"];

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "userName": userName,
        "email": email,
        "age": age,
      };
}
