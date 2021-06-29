part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();
}

class ProductInitialState extends ProductState {
  const ProductInitialState() : super();

  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductState {
  final bool show;

  const ProductLoading({this.show = true}) : super();

  @override
  List<Object> get props => [this.show];
}

class ProductSuccessState extends ProductState {
  String message;
  dynamic data;

  ProductSuccessState({ this.data, this.message }) : super();

  @override
  List<Object> get props => [
    this.data,
    this.message
  ];
}

class ProductErrorState extends ProductState {
  final dynamic error;

  const ProductErrorState({@required this.error}) : super();

  @override
  List<Object> get props => [this.error];
}

class ProductRetrieved extends ProductState {
  final Product product;

  const ProductRetrieved({@required this.product}) : super();

  @override
  List<Object> get props => [this.product];
}

class ProductsRetrievedState extends ProductState {
  final List<Product> products;

  const ProductsRetrievedState({@required this.products}) : super();

  @override
  List<Object> get props => [this.products];
}

class ProductDeleteState extends ProductState {

  const ProductDeleteState(): super();

  @override
  List<Object> get props => [];
}

class AddPhotosState extends ProductState {
  final List<String> photoPaths;

  const AddPhotosState({@required this.photoPaths}) : super();

  @override
  List<Object> get props => [this.photoPaths];
}

class AddPhotosErrorState extends ProductState {
  final String errorStr;

  const AddPhotosErrorState({@required this.errorStr}) : super();

  @override
  List<Object> get props => [this.errorStr];
}

class SetProductPublishState extends ProductState {
  final List<ProductPublish> publishesTo;

  const SetProductPublishState({@required this.publishesTo}) : super();

  @override
  List<Object> get props => [this.publishesTo];
}

class AddedProductCategoryState extends ProductState {
  final ProductCategory productCategory;

  const AddedProductCategoryState({@required this.productCategory})
      : assert(productCategory != null),
        super();

  @override
  List<Object> get props => [this.productCategory];
}

class ProductCategoryRetrievedState extends ProductState {
  final List<ProductCategory> productCategories;

  const ProductCategoryRetrievedState({@required this.productCategories})
      : assert(productCategories != null),
        super();

  @override
  List<Object> get props => [this.productCategories];
}

class ProductCategoryDeleteState extends ProductState {
  final String productCategoryId;

  const ProductCategoryDeleteState({@required this.productCategoryId})
      : assert(productCategoryId != null),
        super();

  @override
  List<Object> get props => [this.productCategoryId];
}

class ProductCategorySelectedState extends ProductState {
  final ProductCategory category;

  const ProductCategorySelectedState({@required this.category})
      : assert(category != null),
        super();

  @override
  List<Object> get props => [this.category];
}

class ProductCategoryDeselectState extends ProductState {
  @override
  List<Object> get props => [];
}

class ProductSubCategoriesPopulatedState extends ProductState {
  final List<ProductCategory> tempSubCategories;

  const ProductSubCategoriesPopulatedState({@required this.tempSubCategories})
      : assert(tempSubCategories != null),
        super();

  @override
  List<Object> get props => [this.tempSubCategories];
}

class ProductSubCategoryDeletedState extends ProductState {
  final ProductCategory subCategory;

  const ProductSubCategoryDeletedState({@required this.subCategory})
      : assert(subCategory != null),
        super();

  @override
  List<Object> get props => [this.subCategory];
}

class ProductSubCategoriesSavedState extends ProductState {
  final List<ProductCategory> subCategories;

  const ProductSubCategoriesSavedState({@required this.subCategories})
      : assert(subCategories != null),
        super();

  @override
  List<Object> get props => [this.subCategories];
}

class ProductSelectState extends ProductState {
  final Product product;

  const ProductSelectState({@required this.product})
      : assert(product != null),
        super();

  @override
  List<Object> get props => [this.product];
}

class RetrieveCompleteOrdersByProductState extends ProductState {
  final Map<String, int> orderDateQuantityMap;

  const RetrieveCompleteOrdersByProductState(
      {@required this.orderDateQuantityMap})
      : assert(orderDateQuantityMap != null),
        super();

  @override
  List<Object> get props => [this.orderDateQuantityMap];
}

class NavigatePopState extends ProductState {
  @override
  List<Object> get props => [];

}
