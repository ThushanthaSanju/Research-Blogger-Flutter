import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:research_blogger/models/rate.dart';

import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionReference = _firestore.collection(
    "ratings");

class RatingService {
  static Future<Response> create(Rate rate) async {
    Response response = Response();

    await _collectionReference.add(rate.toJson()).then((doc) {
      response.status = 201;
      response.message = "Your comment added!";
      response.data = doc.id;
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> update(Rate rate) async {
    Response response = Response();

    await _collectionReference.doc(rate.id).update(rate.toJson()).then((res) {
      response.status = 200;
      response.message = "Comment updated!";
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> delete(String id) async {
    Response response = Response();

    await _collectionReference.doc(id).delete();

    response.status = 200;
    response.message = "Removed successfully!";

    return response;
  }
}