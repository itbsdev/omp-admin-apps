import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/model/user.dart' as Me;
import 'package:admin_app/service/stores_firestore_service.dart';
import 'package:admin_app/service/user_firestore_service.dart';

import 'user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserFirestoreService userFirestoreService;
  final StoresFirestoreService storesFirestoreService;

  UserRepositoryImpl({@required this.userFirestoreService, @required this.storesFirestoreService}): assert(userFirestoreService != null), assert(storesFirestoreService != null);

  @override
  Future<String> delete({String id}) {
    return userFirestoreService.delete(userId: id);
  }

  @override
  Future<String> insert({Me.User datum}) {
    return userFirestoreService.store(user: datum);
  }

  @override
  Future<Me.User> load({String id}) {
    return userFirestoreService.load(userId: id);
  }

  @override
  Stream<List<Me.User>> loadByCompany({String companyId}) {
    throw UnimplementedError("not yet implemented");
  }

  @override
  Future<String> update({Me.User datum}) {
    return userFirestoreService.update(user: datum);
  }

  @override
  Future<Me.User> getLoggedInUser() async {
    final auth = FirebaseAuth.instance;
    print("currentUser.uid: ${auth.currentUser.uid}");
    Me.User user = await load(id: auth.currentUser.uid);

    return Future.value(user);
  }

  @override
  Stream<List<Me.User>> loadAll() {
    return userFirestoreService.loadAll();
  }

}
