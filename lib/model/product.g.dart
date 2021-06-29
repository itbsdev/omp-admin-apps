// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    storeId: json['storeId'] as String,
    quantity: json['quantity'] as int,
    price: (json['price'] as num)?.toDouble(),
    categories: (json['categories'] as List)
        ?.map((e) => e == null
            ? null
            : ProductCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    imageUrls: (json['imageUrls'] as List)?.map((e) => e as String)?.toList(),
    publishesTo: (json['publishesTo'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ProductPublishEnumMap, e))
        ?.toList(),
    reorderPoint: json['reorderPoint'] as int,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    createdAt: json['createdAt'] as num,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'storeId': instance.storeId,
      'quantity': instance.quantity,
      'price': instance.price,
      'categories': instance.categories,
      'imageUrls': instance.imageUrls,
      'publishesTo': instance.publishesTo
          ?.map((e) => _$ProductPublishEnumMap[e])
          ?.toList(),
      'reorderPoint': instance.reorderPoint,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ProductPublishEnumMap = {
  ProductPublish.onlineMarket: 'onlineMarket',
  ProductPublish.marketToHome: 'marketToHome',
  ProductPublish.onlineMarketDeselect: 'onlineMarketDeselect',
  ProductPublish.marketToHomeDeselect: 'marketToHomeDeselect',
};

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) {
  return ProductCategory(
    id: json['id'] as String,
    name: json['name'] as String,
    updatedAt: json['updatedAt'] as num,
    deletedAt: json['deletedAt'] as num,
    createdAt: json['createdAt'] as num,
    parentId: json['parentId'] as String,
  );
}

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parentId': instance.parentId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
    };
