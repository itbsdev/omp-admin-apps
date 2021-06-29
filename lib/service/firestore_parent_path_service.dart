import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreParentPathService {
  final FirebaseFirestore fs = FirebaseFirestore.instance;

  CollectionReference root() {
    if (kReleaseMode) return fs.collection("prod");
    else return fs.collection("stg");
  }

  CollectionReference prodRoot() {
    return fs.collection("prod");
  }
}
