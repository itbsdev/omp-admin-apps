import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/product.dart';
import 'package:admin_app/model/product_category_view.dart';
import 'package:admin_app/model/store.dart';
import 'package:admin_app/model/tag.dart';
import 'package:admin_app/repository/order/order_repository.dart';
import 'package:admin_app/repository/product/product_category_repository.dart';
import 'package:admin_app/repository/product/product_repository.dart';
import 'package:admin_app/repository/tag/tag_repository.dart';
import 'package:admin_app/repository/user/user_repository.dart';
import 'package:admin_app/service/upload_file_service.dart';

import 'package:admin_app/config/extensions.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  final ProductCategoryRepository _productCategoryRepository;
  final UserRepository _userRepository;
  final UploadFileService _uploadFileService;
  final TagRepository _tagsRepository;
  final OrderRepository _orderRepository;

  ProductBloc(
      this._productRepository,
      this._productCategoryRepository,
      this._userRepository,
      this._uploadFileService,
      this._tagsRepository,
      this._orderRepository)
      : assert(_productRepository != null),
        assert(_productCategoryRepository != null),
        assert(_userRepository != null),
        assert(_uploadFileService != null),
        assert(_tagsRepository != null),
        assert(_orderRepository != null),
        super(ProductInitialState()) {
    this._getAllProducts();
    this._getProductCategories();
  }

  Store _store;
  Product _selectedProduct;
  Map<String, int> _orderDateQuantityMap;
  List<String> _filePathsFromInsert = null;
  List<ProductPublish> _publishesProductTo = null;
  List<Product> _products = null;
  Map<int, Product> _lastProductSaved = null;
  List<ProductCategory> _productCategories = null;
  Map<dynamic, List<ProductCategory>> _productSubCategoriesMap = null;
  ProductCategory _selectedProductCategory = null;
  List<ProductCategory> _populatedTempSubCategories;
  List<ProductCategoryView> _selectedSubCategories;

  Map<String, int> get orderDateQuantityMap =>
      _orderDateQuantityMap == null ? Map() : _orderDateQuantityMap;

  List<ProductCategory> get populatedTempSubCategories =>
      _populatedTempSubCategories ?? [];

  ProductCategory get selectedProductCategory => _selectedProductCategory;

  List<ProductPublish> get lastPublishTo =>
      _publishesProductTo == null ? [] : _publishesProductTo;

  List<String> get productImagePaths =>
      _filePathsFromInsert == null ? [] : _filePathsFromInsert;

  List<Product> get products => _products == null ? [] : _products;

  List<ProductCategory> get productCategories =>
      _productCategories == null ? [] : _productCategories;

  void clear() {
    _filePathsFromInsert = null;
    _publishesProductTo = null;
    _selectedSubCategories = null;
    _selectedProductCategory = null;
    _orderDateQuantityMap = null;
    _isProductAlreadySet = false;
  }

  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    super.onTransition(transition);
    // print(transition.toString());
  }

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    // print("product event: $event");
    yield ProductInitialState();

    try {
      if (event is ProductAddEvent) {
        print("add product event was called");
        yield ProductLoading();
        // get all images that are not uploaded
        final unuploadedImageUrls = event.product.imageUrls
            .where((element) => !element.startsWith("http"))
            .toList();
        // remove all  images that are not uploaded

        if (unuploadedImageUrls.isNotEmpty) {
          final downloadImageUrls = unuploadedImageUrls.map((e) async {
            final url = await _uploadFileService.upload(File(e));
            return url;
          }).toList();

          event.product.imageUrls
              .removeWhere((element) => !element.startsWith("http"));

          event.product.imageUrls.addAll(await Future.wait(downloadImageUrls));
        }

        if (event.product.imageUrls.isEmpty) {
          yield ProductLoading(show: false);
          yield ProductErrorState(error: "Please add at least 1 photo");
          return;
        }

        if (event.product.name == null || event.product.name.isEmpty) {
          yield ProductLoading(show: false);
          yield ProductErrorState(error: "Please enter product name");
          return;
        }

        if (event.product.description == null ||
            event.product.description.isEmpty) {
          yield ProductLoading(show: false);
          yield ProductErrorState(error: "Please enter product description");
          return;
        }

        if (event.product.price == null || event.product.price <= 0.0) {
          yield ProductLoading(show: false);
          yield ProductErrorState(error: "Please enter price");
          return;
        }

        if (event.product.quantity == null || event.product.quantity <= 0) {
          yield ProductLoading(show: false);
          yield ProductErrorState(error: "Please enter price");
          return;
        }

        if (event.product.publishesTo.isEmpty) {
          yield ProductLoading(show: false);
          yield ProductErrorState(
              error: "Please check at least 1 venue to publish your product");
          return;
        }

        if (event.product.id != null) {
          print("we are updating product");
          if (_selectedProductCategory == null ||
              _selectedSubCategories == null ||
              _selectedSubCategories.isEmpty) {
            yield ProductLoading(show: false);
            yield ProductErrorState(
                error: "Please enter 1 category and at least 1 sub category");
            return;
          }

          final categories = List<ProductCategory>();

          if (_selectedProductCategory != null) {
            categories.add(_selectedProductCategory);
          }

          if (_selectedSubCategories != null) {
            categories.addAll(_selectedSubCategories.map((e) => e.category));
          }

          if (categories != event.product.categories) {
            event.product.categories = categories;
          }

          await _productRepository.update(datum: event.product);
          // soft delete existing tags for this product
          await _tagsRepository.deleteAllFromProduct(
              productId: event.product.id);

          // create tags here
          final tags = List<String>();
          final productName = event.product.name;
          tags.add(productName.toLowerCase());

          tags.addAll(
              productName.split(" ").map((element) => element.toLowerCase()));

          if (_selectedProductCategory != null) {
            _selectedProductCategory = null;
          }

          if (_selectedSubCategories != null) {
            categories.forEach((category) {
              tags.addAll(
                  category.name.split(" ").map((item) => item.toLowerCase()));
            });

            _selectedSubCategories = null;
          }

          // store product tags
          await Future.forEach(
              tags.map((e) => Tag(productId: event.product.id, tag: e)),
              (element) => _tagsRepository.insert(datum: element));
        } else {
          print("we are storing product");
          final categories = List<ProductCategory>();

          if (_selectedProductCategory != null) {
            categories.add(_selectedProductCategory);
          }

          if (_selectedSubCategories != null) {
            categories.addAll(_selectedSubCategories.map((e) => e.category));
          }

          event.product.categories = categories;
          final productId =
              await _productRepository.insert(datum: event.product);
          print("product input success with id: $productId");

          // create tags here
          final tags = List<String>();
          final productName = event.product.name;
          tags.add(productName.toLowerCase());

          tags.addAll(
              productName.split(" ").map((element) => element.toLowerCase()));

          if (_selectedProductCategory != null) {
            _selectedProductCategory = null;
          }

          if (_selectedSubCategories != null) {
            categories.forEach((category) {
              tags.addAll(
                  category.name.split(" ").map((item) => item.toLowerCase()));
            });

            _selectedSubCategories = null;
          }

          // store product tags
          await Future.forEach(
              tags.map((e) => Tag(productId: productId, tag: e)),
              (element) => _tagsRepository.insert(datum: element));
        }
        _filePathsFromInsert = null;
        _publishesProductTo = null;
        int mapPosition;
        if (event.position != null) {
          mapPosition = event.position;
          print("position is not null.... updating");
          _products[event.position] = event.product;
        } else {
          _products.add(event.product);
          mapPosition = SAVED_NO_POSITION;
        }

        _lastProductSaved = {mapPosition: event.product};
        print("last product saved: $_lastProductSaved");

        yield ProductLoading(show: false);
        yield ProductSuccessState();
      } else if (event is ProductsRetrieved) {
        if (_products == null) _products = List();
        _products.clear();
        _products.addAll(event.products);

        if (_lastProductSaved != null) {
          print("has las product saved ${_lastProductSaved}");
          int position = _lastProductSaved.keys.toList()[0];

          if (position != SAVED_NO_POSITION) {
            _products[position] = _lastProductSaved.values.toList()[0];
            _lastProductSaved = null;
          }
        }
        yield ProductsRetrievedState(products: event.products);
      } else if (event is AddPhotosEvent) {
        print("add photos event was called");
        yield AddPhotosState(photoPaths: event.photoPaths);
      } else if (event is AddPhotosErrorEvent) {
        yield AddPhotosErrorState(errorStr: event.errorStr);
      } else if (event is SetProductPublishEvent) {
        print("publishes to event to state");
        yield SetProductPublishState(publishesTo: event.publishesTo);
      } else if (event is AddProductCategoryEvent) {
        final productCategory = event.productCategory;
        ProductCategory finalProductCategory;

        if (productCategory.id != null &&
            (productCategory.id == _selectedProductCategory.id)) {
          final id =
              await _productCategoryRepository.update(datum: productCategory);
          finalProductCategory = productCategory;
        } else {
          final id =
              await _productCategoryRepository.insert(datum: productCategory);
          final tmp = productCategory.toJson();
          tmp["id"] = id;
          finalProductCategory = ProductCategory.fromJson(tmp);
        }

        _selectedProductCategory = finalProductCategory;
        saveProductCategories();
        yield ProductSuccessState(
            data: _selectedProductCategory,
            message: "Successfully saved category");
      } else if (event is ProductCategoryRetrieveEvent) {
        print("product categories retrieved event here");
        if (_productCategories == null) {
          _productCategories = [];
          _productSubCategoriesMap = Map();
        }

        final tmpCategories = event.productCategories
            .where((element) => element.parentId == null)
            .toList();
        tmpCategories.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

        _productCategories.clear();
        _productSubCategoriesMap.clear();
        _productCategories.addAll(tmpCategories);
        final tmpSubCategories = event.productCategories
            .where((element) => element.parentId != null)
            .toList();
        final groupedCategories =
            groupBy(tmpSubCategories, (category) => category.parentId);
        _productSubCategoriesMap.addAll(groupedCategories);
        yield ProductCategoryRetrievedState(
            productCategories: _productCategories);
      } else if (event is ProductCategoryDeleteEvent) {
        await _productCategoryRepository.delete(id: event.productCategoryId);
        yield ProductSuccessState(message: "Successfully deleted category");
        yield NavigatePopState();
      } else if (event is ProductCategorySelectedEvent) {
        _selectedProductCategory = event.category;
        yield ProductCategorySelectedState(category: event.category);
      } else if (event is ProductCategoryDeselectEvent) {
        yield ProductCategoryDeselectState();
      } else if (event is ProductSubCategoriesPopulatedEvent) {
        print("sub category event triggered");

        if (_populatedTempSubCategories == null)
          _populatedTempSubCategories = [];

        _populatedTempSubCategories.clear();
        _populatedTempSubCategories.addAll(event.tempSubCategories);
        yield ProductSubCategoriesPopulatedState(
            tempSubCategories: event.tempSubCategories);
      } else if (event is ProductSubCategoryDeletedEvent) {
        if (event.subCategory != null && event.subCategory.id != null) {
          if (_populatedTempSubCategories != null &&
              _populatedTempSubCategories.isNotEmpty) {
            final removed =
                _populatedTempSubCategories.remove(event.subCategory);
          }

          await _productCategoryRepository.deleteChild(
              id: event.subCategory.id);
          yield ProductSubCategoryDeletedState(subCategory: event.subCategory);
        }
      } else if (event is ProductSubCategoriesSaveEvent) {
        await Future.forEach(event.subCategories, (ProductCategory element) {
          if (element.id == null) {
            return _productCategoryRepository.insert(datum: element);
          }
        });
        // _populatedTempSubCategories.clear();
        // _selectedProductCategory = null;
        yield ProductSubCategoriesSavedState(
            subCategories: event.subCategories);
      } else if (event is ProductSelectEvent) {
        yield ProductSelectState(product: event.product);
      } else if (event is ProductErrorEvent) {
        yield ProductErrorState(error: event.error);
      } else if (event is RetrieveCompleteOrdersByProductEvent) {
        final orders =
            await _orderRepository.loadByProduct(productId: event.productId);

        final groupedByDateOrders = groupBy(
            orders,
            (order) => presentableDateFormat.format(
                DateTime.fromMillisecondsSinceEpoch(order.updatedAt.toInt(),
                    isUtc: false)));
        final Map<String, int> groupedByDateOrderQuantity = Map();

        groupedByDateOrders.forEach((key, value) {
          var computedQuantity = 0;

          value.forEach((order) => computedQuantity += order.quantity.toInt());

          groupedByDateOrderQuantity[key] = computedQuantity;
        });

        _orderDateQuantityMap = groupedByDateOrderQuantity;

        yield RetrieveCompleteOrdersByProductState(
            orderDateQuantityMap: groupedByDateOrderQuantity);
      } else if (event is ProductDeleteEvent) {
        yield ProductLoading(show: true);
        await _productRepository.delete(id: event.productId);
        _products.removeWhere((element) => element.id == event.productId);
        yield ProductLoading(show: false);
        yield ProductDeleteState();
      }
    } catch (e) {
      print("product_bloc: error: ${e.toString()}");
      yield ProductLoading(show: false);
      yield ProductErrorState(error: e);
    }
  }

  void createProduct(int position,
      {@required String name,
      @required String description,
      @required String quantityStr,
      @required String priceStr}) {
    print(
        "name: $name, description: $description, quantity: $quantityStr, price: $priceStr");
    var quantity = 0;
    var price = 0.0;

    if (_filePathsFromInsert == null || _filePathsFromInsert.isEmpty) {
      add(ProductErrorEvent(error: "Please add at least 1 photo"));
      return;
    }

    if (name == null || name.isEmpty) {
      add(ProductErrorEvent(error: "Please enter product name"));
      return;
    }

    if (description == null || description.isEmpty) {
      add(ProductErrorEvent(error: "Please enter product description"));
      return;
    }

    if (priceStr == null || priceStr.isEmpty) {
      add(ProductErrorEvent(error: "Please enter price"));
      return;
    } else {
      try {
        price = double.parse(priceStr);
      } catch (e) {
        add(ProductErrorEvent(error: "Please enter price"));
        return;
      }
    }

    if (quantityStr == null || quantityStr.isEmpty) {
      add(ProductErrorEvent(error: "Please enter quantity"));
      return;
    } else {
      try {
        quantity = int.parse(quantityStr);
      } catch (e) {
        add(ProductErrorEvent(error: "Please enter quantity"));
        return;
      }
    }

    if (_selectedProductCategory == null) {
      add(ProductErrorEvent(error: "Please choose a category"));
      return;
    }

    if (_selectedSubCategories == null || _selectedSubCategories.isEmpty) {
      add(ProductErrorEvent(error: "Please choose at least 1 sub category"));
      return;
    }

    if (_publishesProductTo == null || _publishesProductTo.isEmpty) {
      add(ProductErrorEvent(
          error: "Please check at least 1 venue to publish your product"));
      return;
    }

    final _product = Product(
        id: _selectedProduct == null ? null : _selectedProduct.id,
        name: name,
        description: description,
        storeId: _store.id,
        quantity: quantity,
        price: price,
        imageUrls: _filePathsFromInsert == null ? [] : _filePathsFromInsert,
        publishesTo: lastPublishTo,
        reorderPoint: 100);

    add(ProductAddEvent(_product, position: position));
  }

  void _getAllProducts() async {
    _productRepository.loadAll().listen((event) {
      // print("products: $event");
      add(ProductsRetrieved(products: event));
    });
  }

  void addPhotos(List<String> paths) {
    print("add photos was called");
    if (_filePathsFromInsert == null) _filePathsFromInsert = List();

    final futurePhotoCount = paths.length + _filePathsFromInsert.length;

    if (futurePhotoCount <= 8) {
      _filePathsFromInsert.addAll(paths);
      final uniquePaths = _filePathsFromInsert.toSet().toList();
      _filePathsFromInsert.clear();
      _filePathsFromInsert.addAll(uniquePaths);
      add(AddPhotosEvent(photoPaths: _filePathsFromInsert));
    } else {
      final additionalPhotoCount = futurePhotoCount - 8;
      add(AddPhotosErrorEvent(
          errorStr:
              "The photos you added is more than $additionalPhotoCount photos from the limit of 8"));
    }
  }

  void setPhotoPaths(List<String> paths) {
    if (paths.length < 8) {
      _filePathsFromInsert = paths;
      add(AddPhotosEvent(photoPaths: _filePathsFromInsert));
    } else
      add(AddPhotosErrorEvent(
          errorStr:
              "Set photos too long from the required maximum of 8 photos"));
  }

  void setPublishTo(ProductPublish productPublish) {
    print("pusblish to: $productPublish");
    if (_publishesProductTo == null) _publishesProductTo = List();
    if (productPublish == ProductPublish.onlineMarketDeselect) {
      _publishesProductTo.remove(ProductPublish.onlineMarket);
    } else if (productPublish == ProductPublish.marketToHomeDeselect) {
      _publishesProductTo.remove(ProductPublish.marketToHome);
    } else {
      _publishesProductTo.add(productPublish);
    }
    print("pusblish to: $_publishesProductTo");

    final distinctPublishes = _publishesProductTo.toSet().toList();
    _publishesProductTo.clear();
    _publishesProductTo.addAll(distinctPublishes);

    add(SetProductPublishEvent(publishesTo: _publishesProductTo));
  }

  bool _isProductAlreadySet = false;

  void setProduct(Product product) {
    print("set product was called");
//    if (!_isProductAlreadySet) {
    print("set product set was called");
    _isProductAlreadySet = true;
    _selectedProduct = product;

    add(RetrieveCompleteOrdersByProductEvent(productId: _selectedProduct.id));
    // setting photo
    _filePathsFromInsert = List<String>();
    _filePathsFromInsert = List.from(product.imageUrls);
    // from products, there should be only 8 photos max.
    add(AddPhotosEvent(photoPaths: _filePathsFromInsert));

    // setting publish
    _publishesProductTo = product.publishesTo;

    final parentCategory =
        product.categories.firstWhere((element) => element.parentId == null);
    final childCategories = product.categories
        .where((element) => element.parentId != null)
        .toList();

    if (parentCategory != null) {
      _selectedProductCategory = parentCategory;
    }

    if (childCategories != null) {
      _selectedSubCategories = childCategories
          .map((e) => ProductCategoryView(category: e, selected: true))
          .toSet()
          .toList();
    }

    add(ProductSelectEvent(product: product));
//    }
  }

  void resetPhotos() {
    _filePathsFromInsert = null;
  }

  void setLastPublishTo(List<ProductPublish> publishTo) {
    print("last publish  to: $publishTo");
    _publishesProductTo = publishTo;
  }

  void addProductCategory(String name) {
    ProductCategory category;

    if (_selectedProductCategory == null) {
      category = ProductCategory(id: null, name: name);
    } else {
      _selectedProductCategory.name = name;
      category = _selectedProductCategory;
    }

    add(AddProductCategoryEvent(productCategory: category));
  }

  void addProductSubCategory(String name) {
    if (_selectedProductCategory != null &&
        _selectedProductCategory.id != null) {
      final List<String> subCategories = name.split(",");

      if (subCategories != null && subCategories.isNotEmpty) {
        final tempSubCategories = subCategories
            .map((e) => ProductCategory(
                id: null, name: e, parentId: _selectedProductCategory.id))
            .toList();
        add(ProductSubCategoriesPopulatedEvent(
            tempSubCategories: tempSubCategories));
      }
    } else {
      add(ProductErrorEvent(error: "Please save a category first"));
    }
  }

  void removeSubCategory(ProductCategory subCategory) {
    add(ProductSubCategoryDeletedEvent(subCategory: subCategory));
  }

  void selectCategory(ProductCategory category) {
    print("category: $category selected");
    _selectedSubCategories = null;
    add(ProductCategorySelectedEvent(category: category));
  }

  void deselectCategory() {
    add(ProductCategoryDeselectEvent());
  }

  void saveProductCategories() {
    if (_populatedTempSubCategories != null) {
      add(ProductSubCategoriesSaveEvent(
          subCategories: _populatedTempSubCategories));
    }
  }

  void _getProductCategories() {
    _productCategoryRepository.loadByCompany(companyId: null).listen((event) {
      print("product categories retrieved");
      add(ProductCategoryRetrieveEvent(productCategories: event));
    });
  }

  void removeProductCategory(ProductCategory category) {
    add(ProductCategoryDeleteEvent(productCategoryId: category.id));
  }

  List<ProductCategoryView> getSubCategories(String categoryId) {
    if (_selectedSubCategories != null) {
      return _productSubCategoriesMap[categoryId]
          .map((e) => ProductCategoryView(
              category: e,
              selected: _selectedSubCategories
                  .any((element) => element.category.id == e.id)))
          .toList();
    }

    try {
      return _productSubCategoriesMap[categoryId]
          .map((e) => ProductCategoryView(category: e, selected: false))
          .toList();
    } catch (err) {
      return [];
    }
  }

  void selectSubCategory(ProductCategoryView subCategory) {
    if (_selectedSubCategories == null) _selectedSubCategories = List();

    if (subCategory.selected) {
      _selectedSubCategories.removeWhere(
          (category) => category.category.id == subCategory.category.id);
    } else {
      _selectedSubCategories.add(subCategory);
    }

    print("current sub categories selected $_selectedSubCategories");
  }

  void deleteProduct() {
    if (_selectedProduct == null) {
      add(ProductErrorEvent(
          error: "Cannot perform action. Product is not set"));
      return;
    }

    add(ProductDeleteEvent(productId: _selectedProduct.id));
  }

  void resetProductCategory() {
    _selectedProductCategory = null;
    _populatedTempSubCategories = null;
    _selectedSubCategories = null;
  }
}
