import 'package:admin_app/bloc/product/product_bloc.dart';
import 'package:admin_app/features/product_categories/add_product_category.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext rootContext) {
    final productBloc = BlocProvider.of<ProductBloc>(rootContext);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
          child: Row(
            children: [
              OpenContainer(closedBuilder: (containerContext, action) {
                return ElevatedButton(onPressed: () => action(),
                    child: Padding(
                      padding: EdgeInsets.all(12.0), child: Row(
                      children: [
                        Icon(Icons.add_circle_outline_rounded),
                        SizedBox(width: 8.0,),
                        Text("Add Category")
                      ],
                    ),));
              }, openBuilder: (containerContext, action) {
                return AddProductCategoryScreen();
              },
              tappable: false,)
            ],
          ),
        ),
        Expanded(child: BlocBuilder<ProductBloc, ProductState>(
          builder: (blocContext, state) {
            return ListView.separated(itemBuilder: (builderContext, index) {
              final productCategory = productBloc.productCategories[index];

              return OpenContainer(
                closedElevation: 0.0,
                closedColor: Colors.transparent,
                closedBuilder: (containerContext, action) {
                return ListTile(
                  title: Text(productCategory.name),
                  subtitle: Text("${productBloc.getSubCategories(productCategory.id).map((e) => e.category.name).join(", ")}"),
                  onTap: () {
                    productBloc.selectCategory(productCategory);
                    action();
                  },
                );
              }, openBuilder: (containerContext, action) {
                return AddProductCategoryScreen(category: productCategory,);
              },
              tappable: false,);
            },
                separatorBuilder: (builderContext, index) => Divider(),
                itemCount: productBloc.productCategories.length);
          },
        ))
      ],
    );
  }
}
