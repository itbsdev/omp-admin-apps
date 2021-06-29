import 'package:flutter/material.dart';
import 'package:admin_app/model/product.dart';

class ProductCategoryView {
  final ProductCategory category;
  bool selected;

  ProductCategoryView({ @required this.category, this.selected }): assert(category != null);
}
