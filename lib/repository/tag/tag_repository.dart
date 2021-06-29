
import 'package:flutter/material.dart';
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/tag.dart';

abstract class TagRepository with BaseRepository<Tag> {
  Future<bool> deleteAllFromProduct({ @required String productId });
}
