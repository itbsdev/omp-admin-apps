import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable(nullable: true)
class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String storeId;
  int quantity;
  final double price;
  List<ProductCategory> categories;
  final List<String> imageUrls;
  final List<ProductPublish> publishesTo;
  final int reorderPoint;
  final num createdAt;
  final num updatedAt;
  num deletedAt;

  Product(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.storeId,
      @required this.quantity,
      @required this.price,
      @required this.categories,
      @required this.imageUrls,
      @required this.publishesTo,
      @required this.reorderPoint,
      @required this.updatedAt,
      @required this.deletedAt,
      this.createdAt});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object> get props => [
        this.id,
        this.name,
        this.description,
        this.storeId,
        this.quantity,
        this.price,
        this.categories,
        this.imageUrls,
        this.publishesTo,
        this.reorderPoint,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
      ];
}

@JsonSerializable(nullable: true)
class ProductCategory extends Equatable {
  final String id;
  String name;
  final String parentId;
  final num createdAt;
  final num updatedAt;
  num deletedAt;

  ProductCategory(
      {@required this.id,
      @required this.name,
      @required this.updatedAt,
      this.deletedAt,
      this.createdAt,
      this.parentId});

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);

  @override
  List<Object> get props => [this.id, this.name];
}

/// TODO: to be completed
/// product details should be flat with product
/// current scenario for getting product is
/// staging / dev: fs.collection("stg").doc("productDoc").collection("products")
/// prod: fs.collection("prod").doc("productDoc").collection("products")
///
/// for product details to be flat, it should be like this
/// staging / dev: fs.collection("stg").doc("productDoc").collection("details")
/// prod: fs.collection("stg").doc("productDoc").collection("details")
///
class ProductDetails extends Equatable {
  /// id of the detail
  String id;

  /// product id this detail is referenced to.
  String productId;
  String brand;
  String build;
  String model;
  int yearModel;

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// enum will have the values of int by index.
/// so, it is possible that when enum is stored in
/// firestore, they will be converted as int.
enum ProductPublish {
  onlineMarket,
  marketToHome,
  onlineMarketDeselect,
  marketToHomeDeselect
}
