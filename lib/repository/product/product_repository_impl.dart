import 'package:flutter/material.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/repository/product/product_repository.dart';
import 'package:admin_app/service/product_firestore_service.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductFirestoreService productFirestoreService;

  ProductRepositoryImpl(
      {@required this.productFirestoreService})
      : assert(productFirestoreService != null);

  @override
  Future<String> delete({String id}) {
    return productFirestoreService.delete(productId: id);
  }

  @override
  Future<String> insert({Product datum}) {
    return productFirestoreService.store(product: datum);
  }

  @override
  Future<Product> load({String id}) {
    return productFirestoreService.load(productId: id);
  }

  @override
  Stream<List<Product>> loadByCompany({String companyId}) {
    return productFirestoreService.loadByCompany(companyId: companyId);
  }

  @override
  Future<String> update({Product datum}) {
    return productFirestoreService.update(product: datum);
  }

  @override
  Stream<List<Product>> loadAll() {
    return productFirestoreService.loadAll();
  }

  @override
  Future<List<Product>> loadByCompanyAsync({String storeId}) {
    return productFirestoreService.loadByCompanyAsync(companyId: storeId);
  }
}
