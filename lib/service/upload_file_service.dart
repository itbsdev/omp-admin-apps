import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class UploadFileService {
  final storageRef = FirebaseStorage.instance.ref();

  Future<String> upload(File file) async {
    final String baseName = basename(file.path);
    final task = await storageRef.child("images/$baseName").putFile(file);
    final downloadUrl = await task.ref.getDownloadURL();

    return Future.value(downloadUrl);
  }
}
