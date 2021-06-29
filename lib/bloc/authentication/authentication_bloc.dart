import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/repository/user/user_repository.dart';
import 'package:admin_app/service/authentication_service.dart';
import 'package:admin_app/model/user.dart' as Me;

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  final AuthenticationService authenticationService;
  FirebaseAuth _auth;

  AuthenticationBloc(
      {@required this.userRepository, @required this.authenticationService})
      : assert(userRepository != null),
        assert(authenticationService != null),
        super(AuthenticationInitial()) {
    _auth = FirebaseAuth.instance;
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    print("event reached here");
    yield AuthenticationInitial();

    try {
      if (event is LoginEvent) {
        print("event reached here2");
        yield AuthenticationLoadingState();

        final userName = event.userName;
        final password = event.password;

        final response = await authenticationService.login(
            userName: userName, password: password);

        if (response != null) {
          print("response: $response");
          final error = response["data"]["error"];

          if (error != null) {
            throw Exception(error);
          }

          print("token: ${response["data"]["token"]}");
          print("firstName: ${response["data"]["profile"]["firstname"]}");
          // check for user's existence
          final authResponse = await authenticationService.authenticate(token: response["data"]["token"]);
          Me.User user = await userRepository.getLoggedInUser();

          if (user == null) {
            user = Me.User(
              id: _auth.currentUser.uid,
              name: "${ response["data"]["profile"]["firstname"] } ${response["data"]["profile"]["middlename"]} ${response["data"]["profile"]["lastname"]}",
              email: response["data"]["profile"]["email"],
              userId: response["data"]["profile"]["id"], // this could be changed by the response from the backend
              mobileNumber: response["data"]["profile"]["mobileno"],
            );
            await _auth.currentUser.updateProfile(displayName: user.name);
            await _auth.currentUser.updateEmail(user.email);
            await userRepository.insert(datum: user);
          }
        } else {
          yield AuthenticationErrorState(err: "Something went wrong while logging in...");
        }
      } else if (event is LogoutEvent) {
        yield LogoutState();
      }
    } catch (err) {
      print("error: $err");

      if (err is FirebaseAuthException) {
        yield AuthenticationErrorState(err: "${err.message}");
      } else {
        yield AuthenticationErrorState(err: err.toString());
      }
    }
  }

  void login(String username, String password) {
    print("login clicked");
    add(LoginEvent(userName: username, password: password));
    print("login passed with data: $username and $password");
  }

  void logout() async {
    try {
      await _auth.signOut();
      add(LogoutEvent());
    } catch(err) { print("error logging out $err"); }
  }

  bool loggedInCheck() => _auth.currentUser != null;
}

/// /// NOTE TO SELF: uncomment line below when everything from the backend side is ok
//          final authResponse = await authenticationService.authenticate(token: response["token"]);
//          final userStoreMap = await userRepository.getLoggedInMerchant();
//          Me.User user = userStoreMap.keys.first;
//          Store store = userStoreMap.values.first;
//
//          if (user == null) {
//            ///  NOTE TO SELF: since we are using a temporary auth, please be mindful
//            ///  of the user data when getting the user data from the backend server
//            user = Me.User(
//              id: _auth.currentUser.uid,
//              name: "${ response["profile"]["firstname"] } ${response["profile"]["middlename"]} ${response["profile"]["lastname"]}",
//              email: response["profile"]["email"],
//              userId: response["profile"]["id"], // this could be changed by the response from the backend
//              mobileNumber: response["profile"]["mobileno"],
//            );
//            await _auth.currentUser.updateProfile(displayName: user.name);
//            await _auth.currentUser.updateEmail(user.email);
//            await userRepository.insert(datum: user);
