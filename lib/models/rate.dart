import 'package:cloud_firestore/cloud_firestore.dart';

class Rate {
  String? id;
  double? rate;
  String? comment;
  String? uid;
  String relatedPost;

  Rate({this.rate, this.comment, this.id, this.uid, required this.relatedPost});

  Rate.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        rate = doc.data()!["rate"] as double,
        comment = doc.data()!["comment"],
        uid = doc.data()!["uid"],
        relatedPost = doc.data()!["relatedPost"];

  Map<String, dynamic> toJson() => {
    "rate": rate,
    "comment": comment,
    "uid": uid,
    "relatedPost" : relatedPost,
  };
}
