part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class ProductAddEvent extends ProductEvent {
  final Product product;
  final int position;
  const ProductAddEvent(this.product, {this.position}): super();

  @override
  List<Object> get props => [this.product];
}

class ProductUpdateEvent extends ProductEvent {
  final Product product;

  const ProductUpdateEvent({@required this.product }): super();

  @override
  List<Object> get props => [this.product];
}

class ProductDeleteEvent extends ProductEvent {
  final String productId;

  const ProductDeleteEvent({@required this.productId}): assert(productId != null), super();

  @override
  List<Object> get props => [this.productId];
}

class ProductRetrieve extends ProductEvent {
  final String productId;

  const ProductRetrieve({@required this.productId}): super();

  @override
  List<Object> get props => [this.productId];
}

class ProductsRetrieve extends ProductEvent {
  final String companyId;

  const ProductsRetrieve({@required this.companyId}): super();

  @override
  List<Object> get props => [this.companyId];
}

class ProductsRetrieved extends ProductEvent {
  final List<Product> products;

  const ProductsRetrieved({@required this.products}): super();

  @override
  List<Object> get props => [this.products];

}

class AddPhotosEvent extends ProductEvent {
  final List<String> photoPaths;

  const AddPhotosEvent({@required this.photoPaths}): super();

  @override
  List<Object> get props => [this.photoPaths];
}

class AddPhotosErrorEvent extends ProductEvent {
  final String errorStr;
  const AddPhotosErrorEvent({@required this.errorStr}): super();

  @override
  List<Object> get props => [this.errorStr];
}

class SetProductPublishEvent extends ProductEvent {
  final List<ProductPublish> publishesTo;

  const SetProductPublishEvent({@required this.publishesTo}): super();

  @override
  List<Object> get props => [this.publishesTo];

}

class AddProductCategoryEvent extends ProductEvent {
  final ProductCategory productCategory;

  const AddProductCategoryEvent({@required this.productCategory}): assert(productCategory != null), super();

  @override
  List<Object> get props => [this.productCategory];

}

class ProductCategoryRetrieveEvent extends ProductEvent {
  final List<ProductCategory> productCategories;

  const ProductCategoryRetrieveEvent({@required this.productCategories}): assert(productCategories != null), super();

  @override
  List<Object> get props => [this.productCategories];
}

class ProductCategoryDeleteEvent extends ProductEvent {
  final String productCategoryId;

  const ProductCategoryDeleteEvent({@required this.productCategoryId}): assert(productCategoryId != null), super();

  @override
  List<Object> get props => [this.productCategoryId];
}

class ProductCategorySelectedEvent extends ProductEvent {
  final ProductCategory category;

  const ProductCategorySelectedEvent({@required this.category }): assert(category != null), super();

  @override
  List<Object> get props => [this.category];
}

class ProductCategoryDeselectEvent extends ProductEvent {
  @override
  List<Object> get props => [];
}

class ProductSubCategoriesPopulatedEvent extends ProductEvent {
  final List<ProductCategory> tempSubCategories;

  const ProductSubCategoriesPopulatedEvent({ @required this.tempSubCategories }): assert(tempSubCategories != null), super();

  @override
  List<Object> get props => [this.tempSubCategories];
}

class ProductSubCategoryDeletedEvent extends ProductEvent {
  final ProductCategory subCategory;

  const ProductSubCategoryDeletedEvent({ @required this.subCategory }): assert(subCategory != null), super();

  @override
  List<Object> get props => [this.subCategory];
}

class ProductSubCategoriesSaveEvent extends ProductEvent {
  final List<ProductCategory> subCategories;

  const ProductSubCategoriesSaveEvent({ @required this.subCategories}): assert(subCategories != null), super();

  @override
  List<Object> get props => [this.subCategories];
}

class ProductSelectEvent extends ProductEvent {
  final Product product;

  const ProductSelectEvent({ @required this.product}): assert(product != null), super();

  @override
  List<Object> get props => [this.product];
}

class ProductErrorEvent extends ProductEvent {
  final String error;

  const ProductErrorEvent({ @required this.error }): assert(error != null), super();

  @override
  List<Object> get props => [this.error];
}

class RetrieveCompleteOrdersByProductEvent extends ProductEvent {
  final String productId;

  const RetrieveCompleteOrdersByProductEvent({ @required this.productId }): assert(productId != null), super();

  @override
  List<Object> get props => [this.productId];
}
