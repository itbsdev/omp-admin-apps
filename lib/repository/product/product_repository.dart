
import 'package:flutter/material.dart';
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/product.dart';

/// controls where the product data should be saved
abstract class ProductRepository with BaseRepository<Product> {
  Stream<List<Product>> loadAll();

  Future<List<Product>> loadByCompanyAsync({ @required String storeId });
}
