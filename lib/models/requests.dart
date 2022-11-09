import 'package:cloud_firestore/cloud_firestore.dart';

class Requests {
  String? id;
  String title;
  String language;
  String message;
  String uid;
  String receiver;

  Requests(
      {this.id,
      required this.title,
      required this.language,
      required this.message,
      required this.uid,
      required this.receiver});

  Requests.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        title = doc.data()!["title"],
        language = doc.data()!["language"],
        message = doc.data()!["message"],
        receiver = doc.data()!["receiver"],
        uid = doc.data()!["uid"];

  Map<String, dynamic> toJson() => {
        "title": title,
        "language": language,
        "message": message,
        "uid": uid,
        "receiver": receiver,
      };
}
