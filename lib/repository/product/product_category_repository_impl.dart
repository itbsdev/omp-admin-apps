import 'package:flutter/material.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/repository/product/product_category_repository.dart';
import 'package:admin_app/service/product_category_firestore_service.dart';

class ProductCategoryRepositoryImpl extends ProductCategoryRepository {
  final ProductCategoryFirestoreService productCategoryFirestoreService;

  ProductCategoryRepositoryImpl(
      {@required this.productCategoryFirestoreService}):
        assert(productCategoryFirestoreService != null);

  @override
  Future<String> delete({String id}) {
    return productCategoryFirestoreService.delete(productCategoryId: id, includeChildren: true);
  }

  @override
  Future<String> deleteChild({String id}) {
    return productCategoryFirestoreService.delete(productCategoryId: id);
  }

  @override
  Future<String> insert({ProductCategory datum}) {
    return productCategoryFirestoreService.store(productCategory: datum);
  }

  @override
  Future<ProductCategory> load({String id}) {
    return productCategoryFirestoreService.load(productId: id);
  }

  @override
  Stream<List<ProductCategory>> loadByCompany({String companyId}) {
    return productCategoryFirestoreService.loadAll();
  }

  @override
  Future<String> update({ProductCategory datum}) {
    return productCategoryFirestoreService.update(productCategory: datum);
  }
}
