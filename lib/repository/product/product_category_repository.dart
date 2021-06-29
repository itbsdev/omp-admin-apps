
import 'package:flutter/material.dart';
import 'package:admin_app/core/base_repository.dart';
import 'package:admin_app/model/product.dart';

/// controls where the product data should be saved
abstract class ProductCategoryRepository with BaseRepository<ProductCategory> {
  Future<String> deleteChild({String id});
}
