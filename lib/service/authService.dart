import 'package:firebase_auth/firebase_auth.dart';

import '../models/response.dart';

class AuthService {
  static Future<Response> register(
      {required String email, required String password}) async {
    Response response = Response();

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((res) {
      response.status = 201;
      response.message = "User registered successfully!";
      response.data = res.user;
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> login(
      {required String email, required String password}) async {
    Response response = Response();

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((session) {
      response.status = 200;
      response.message = "User logged successfully!";
      response.data = session.user;
    }).catchError((e) {
      response.status = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Response getCurrentUser() {
    Response response = Response();

    var user = FirebaseAuth.instance
        .currentUser;

    if (user != null) {
      response.status = 200;
      response.message = "Current user fetched!";
      response.data = user;
    }

    return response;
  }

  static Future<Response> deleteUser(String password) async {
    var user = FirebaseAuth.instance
        .currentUser;

    var credentials = EmailAuthProvider.credential(
        email: user?.email as String, password: password);
    await
    user?.reauthenticateWithCredential(credentials);

    await user?.delete();

    Response response = Response();
    response.status = 200;
    response.message = "Account removed";

    return response;
  }
}
