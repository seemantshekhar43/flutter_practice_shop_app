import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {

  final showFavoritesOnly;
  ProductsGrid({this.showFavoritesOnly});



  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavoritesOnly? productsData.favoriteItems: productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(
//            id: products[i].id,
//            title: products[i].title,
//            imageUrl: products[i].imageUrl,
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10.0),
    );
  }
}
