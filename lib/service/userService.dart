import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:research_blogger/models/response.dart';
import 'package:research_blogger/models/user.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionReference = _firestore.collection("users");

class UserService {
  static Future<Response> create(User user) async {
    Response response = Response();

    DocumentReference documentReference = _collectionReference.doc();

    await documentReference.set(user.toJson()).whenComplete(() {
      response.status = 201;
      response.message = "User created successfully!";
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> getUser(String uid) async {
    Response response = Response();

   await  _collectionReference.where("uid", isEqualTo: uid).get().then((doc) {
     response.status = 200;
     response.message = "User fetched success";
     response.data = User.fromDocumentSnapshot(doc.docs.first as DocumentSnapshot<Map<String, dynamic>>);
   });

    return response;
  }

  static Future<Response> getUserByName(String name) async {
    Response response = Response();

    await  _collectionReference.where("userName", isEqualTo: name).get().then((doc) {
      response.status = 200;
      response.message = "User fetched success";
      response.data = User.fromDocumentSnapshot(doc.docs.first as DocumentSnapshot<Map<String, dynamic>>);
    });

    return response;
  }

  static Future<Response> updateUser(User user) async {
    Response response = Response();

    await _collectionReference.doc(user.id).update(user.toJson()).then((res) {
      response.status = 200;
      response.message = "User updated";
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> deleteUser(String id) async {
    Response response = Response();

    await _collectionReference.doc(id).delete();

    response.status = 200;
    response.message = "Delete user";

    return response;
  }
}
