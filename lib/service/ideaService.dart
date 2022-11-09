import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:research_blogger/models/idea.dart';
import 'package:research_blogger/models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionReference = _firestore.collection("ideas");

class IdeaService {
  static Future<Response> create(Idea idea) async {
    Response response = Response();

    DocumentReference documentReference = _collectionReference.doc();

    await documentReference.set(idea.toJson()).then((doc) {
      response.status = 201;
      response.message = "Idea added successfully!";
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> getById(String id) async {
    Response response = Response();

    await _collectionReference.doc(id).get().then((snapshot) {
      response.status = 200;
      response.message = "Fetch idea success";
      response.data = Idea.fromDocumentSnapshot(snapshot as DocumentSnapshot<Map<String, dynamic>>);
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> update(Idea idea) async {
    Response response = Response();

    await _collectionReference.doc(idea.id).update(idea.toJson()).then((res) {
      response.status = 200;
      response.message = "Updated success";
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }
}