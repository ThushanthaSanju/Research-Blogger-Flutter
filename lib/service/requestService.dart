import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:research_blogger/models/requests.dart';

import '../models/response.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionReference = _firestore.collection(
    "requests");

class RequestService {
  static Future<Response> create(Requests requests) async {
    Response response = Response();

    DocumentReference documentReference = _collectionReference.doc();

    await documentReference.set(requests.toJson()).then((doc) {
      response.status = 201;
      response.message = "Request added successfully!";
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> getByUId(String uid) async {
    Response response = Response();

    await _collectionReference.where("uid", isEqualTo: uid).get().then((doc) {
      response.status = 200;
      response.message = "Request fetched success";
      response.data = Requests.fromDocumentSnapshot(doc.docs.first as DocumentSnapshot<Map<String, dynamic>>);
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


  static Future<Response> update(Requests requests) async {
    Response response = Response();

    await _collectionReference.doc(requests.id).set(requests.toJson()).then((e) {
      response.status = 200;
      response.message = "Request updated";
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }
}