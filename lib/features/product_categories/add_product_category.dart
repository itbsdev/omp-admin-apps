import 'package:admin_app/bloc/product/product_bloc.dart';
import 'package:admin_app/config/extensions.dart';
import 'package:admin_app/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tags/flutter_tags.dart';

class AddProductCategoryScreen extends StatelessWidget {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final ProductCategory category;

  AddProductCategoryScreen({ Key key, this.category }): super(key: key) {
    if (category != null) {
      _categoryController.text = category.name;
    }
  }

  @override
  Widget build(BuildContext rootContext) {
    final productBloc = BlocProvider.of<ProductBloc>(rootContext);

    return WillPopScope(child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("${category == null ? "Add" : "Update"} Product Category"),
        actions: [
          IconButton(icon: Icon(Icons.delete_rounded), onPressed: () {
            if (productBloc.selectedProductCategory != null) {
              showConfirmDialog(
                  context: rootContext,
                  message: "Deleting this category will remove all its sub categories. Do you want to continue?",
                  title: "This action is permanent",
                  positiveAction: () {
                    productBloc.removeProductCategory(productBloc.selectedProductCategory);
                  }
              );
            }
          })
        ],
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (listenerContext, state) {
          if (state is ProductErrorState) {
            ScaffoldMessenger.of(listenerContext)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is ProductSuccessState) {
            if (state.message != null) {
              ScaffoldMessenger.of(listenerContext)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          } else if (state is NavigatePopState) {
            Navigator.pop(listenerContext);
          }
        },
        child: Builder(
            builder: (builderContext) => Stack(
              children: [
                SvgPicture.asset(
                  "assets/images/bg.svg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                ListView(
                  padding: DEFAULT_SPACING,
                  children: [
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                          labelText: "Category Name",
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _subCategoryController,
                      decoration: InputDecoration(
                          labelText: "Sub Category",
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.done_rounded),
                              onPressed: () {
                                final categoryName =
                                    _categoryController.text;
                                if (categoryName == null ||
                                    categoryName.trim().isEmpty) {
                                  ScaffoldMessenger.of(builderContext)
                                      .showSnackBar(SnackBar(
                                      content: Text(
                                          "Please save a category first")));
                                } else {
                                  productBloc.addProductSubCategory(
                                      _subCategoryController.text);
                                }
                              })),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    BlocBuilder<ProductBloc, ProductState>(
                        cubit: productBloc,
                        builder: (blocContext, state) {
                          if (productBloc.selectedProductCategory == null)
                            return Container();

                          final subCategories =
                          productBloc.getSubCategories(
                              productBloc.selectedProductCategory.id);
                          return Tags(
                            itemCount: subCategories.length, // required
                            columns: 6,
                            itemBuilder: (int index) {
                              final subCategoryView = subCategories[index];

                              return ItemTags(
                                // Each ItemTags must contain a Key. Keys allow Flutter to
                                // uniquely identify widgets.
                                key: Key(index.toString()),
                                index: index,
                                // required
                                title: subCategoryView.category.name,
                                active: subCategoryView.selected,
                                customData: "subCategoryView",
                                border: Border(),
                                textStyle: TextStyle(
                                  fontSize: 14.0,
                                ),
                                combine: ItemTagsCombine.withTextAfter,
//                            image: ItemTagsImage(
//                                image: AssetImage("img.jpg") // OR NetworkImage("https://...image.png")
//                            ), // OR null,
//                            icon: ItemTagsIcon(
//                              icon: Icons.add,
//                            ), // OR null,
//                            removeButton: ItemTagsRemoveButton(
//                              onRemoved: (){
//                                // Remove the item from the data source.
//                                setState(() {
//                                  // required
//                                  _items.removeAt(index);
//                                });
//                                //required
//                                return true;
//                              },
//                            ), // OR null,
                                onPressed: (item) => print("pressed"),
                                onLongPressed: (item) => print(item),
                                removeButton: ItemTagsRemoveButton(
                                  onRemoved: () {
                                    productBloc.removeSubCategory(subCategoryView.category);
                                    return true;
                                  },
                                ),
                              );
                            },
                          );
                        }),
                    // Container(
                    //     height: 400.0,
                    //     child: BlocBuilder<ProductBloc, ProductState>(
                    //         cubit: productBloc,
                    //         builder: (context, state) {
                    //           return GridView.count(
                    //             crossAxisCount: 3,
                    //             children: [
                    //               ElevatedButton(onPressed: () => productBloc.saveProductCategories(), child: Text("Save sub categories"),),
                    //               // for (var subCategory
                    //               // in productBloc.populatedTempSubCategories)
                    //               //   Chip(
                    //               //       label: Text(subCategory.name),
                    //               //       deleteIcon: Icon(Icons.cancel_rounded),
                    //               //       onDeleted: () => productBloc
                    //               //           .removeSubCategory(subCategory))
                    //               for (var index = 0; index < 10; index ++)
                    //                 Chip(
                    //                     label: Text("${index} subcategory"),
                    //                     deleteIcon: Icon(Icons.cancel_rounded),
                    //                     onDeleted: () => print("deltee"))
                    //             ],
                    //           );
                    //         })),
                    SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton(
                        onPressed: () => productBloc.addProductCategory(_categoryController.text),
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text("SAVE"),
                        ))
                  ],
                )
              ],
            )),
      ),
    ), onWillPop: () {
      productBloc.resetProductCategory();
      return Future.value(true);
    });
  }
}
