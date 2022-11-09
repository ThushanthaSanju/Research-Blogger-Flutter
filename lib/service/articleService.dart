import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:research_blogger/models/article.dart';
import 'package:research_blogger/models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionReference = _firestore.collection(
    "articles");

class ArticleService {
  static Future<Response> create(Article article) async {
    Response response = Response();

    DocumentReference documentReference = _collectionReference.doc();

    await documentReference.set(article.toJson()).then((doc) {
      response.status = 201;
      response.message = "Article added successfully!";
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
      response.data = Article.fromDocumentSnapshot(snapshot as DocumentSnapshot<Map<String, dynamic>>);
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }


  static Future<Response> update(Article article) async {
    Response response = Response();

    await _collectionReference.doc(article.id).update(article.toJson()).then((res) {
      response.status = 200;
      response.message = "Updated success";
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }
}