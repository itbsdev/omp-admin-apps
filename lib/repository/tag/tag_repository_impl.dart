import 'package:flutter/material.dart';
import 'package:admin_app/model/tag.dart';
import 'package:admin_app/service/tags_firestore_service.dart';

import 'tag_repository.dart';

class TagRepositoryImpl extends TagRepository {
  final TagsFirestoreService tagsFirestoreService;

  TagRepositoryImpl({@required this.tagsFirestoreService});

  @override
  Future<String> delete({String id}) {
    return tagsFirestoreService.delete(tagId: id);
  }

  @override
  Future<String> insert({Tag datum}) {
    return tagsFirestoreService.store(tag: datum);
  }

  @override
  Future<Tag> load({String id}) {
    return tagsFirestoreService.load(tagId: id);
  }

  @override
  Stream<List<Tag>> loadByCompany({String companyId}) {
    throw UnimplementedError("not yet implemented");
  }

  @override
  Future<String> update({Tag datum}) {
    return tagsFirestoreService.update(tag: datum);
  }

  @override
  Future<bool> deleteAllFromProduct({String productId}) {
    return tagsFirestoreService.deleteAllFromProduct(productId: productId);
  }
}
