import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/config/extensions.dart';

class AuthenticationService {
  Future<dynamic> login({String userName, String password}) async {
    if (userName == null || password == null) {
      Future.error(defaultResponse(
          isError: true, message: "Username or password is not defined"));
    }

    final http.Client client = http.Client();
    final loginUrl = "$BASE_FIREBASE_FUNCTIONS_API_URL/login";

    try {
      final response = await client
          .post(loginUrl, body: {"userName": userName, "password": password});
      return Future.value(jsonDecode(response.body));
    } catch (err) {
      return Future.error(defaultResponse(
          isError: true,
          message: "An error occurred while requesting for login",
          data: err));
    } finally {
      client.close();
    }
  }

  Future<dynamic> loginTemporary({String userName, String password}) async {
    if (userName == null || password == null) {
      Future.error(defaultResponse(
          isError: true, message: "Username or password is not defined"));
    }

    final http.Client client = http.Client();
    final loginUrl = "$BASE_FIREBASE_FUNCTIONS_API_URL/login";
    final auth = FirebaseAuth.instance;

    try {
      final response = await auth.signInWithEmailAndPassword(
          email: userName, password: password);
      return Future.value(response);
    } catch (err) {
      return Future.error(defaultResponse(
          isError: true,
          message: "An error occurred while requesting for login",
          data: err));
    } finally {
      client.close();
    }
  }

  Future<dynamic> verify({String uuid}) async {
    if (uuid == null) {
      Future.error(defaultResponse(message: "UUID is not defined"));
    }

    final http.Client client = http.Client();
    final verifyUrl = "$BASE_FIREBASE_FUNCTIONS_API_URL/verify";

    try {
      final response = await client.post(verifyUrl, body: {"uuid": uuid});

      return Future.value(response.body);
    } catch (err) {
      return Future.error(defaultResponse(
          isError: true,
          message: "An error occurred while requesting for login",
          data: err));
    } finally {
      client.close();
    }
  }

  /// the function will authenticate the user based on the token. If the  user
  /// of this token does not exist, it will create an account in the firebase
  /// auth.
  Future<dynamic> authenticate({String token}) async {
    final auth = FirebaseAuth.instance;

    try {
      final response = await auth.signInWithCustomToken(token);

      return Future.value(response);
    } catch (err) {
      return Future.error(defaultResponse(
          isError: true,
          message: "Something went wrong while signing in with custom token",
          data: err));
    }
  }

  Map<String, dynamic> defaultResponse(
      {isError: bool, String message, dynamic data}) {
    assert(isError != null, "Please provide isError'");
    return Map.of({"success": !isError, "message": message, "data": data});
  }
}
