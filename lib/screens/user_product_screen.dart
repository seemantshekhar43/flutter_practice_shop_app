import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';


  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
            children: <Widget>[
              UserProductItem(
                productId: productsData.items[i].id,
                productImageUrl: productsData.items[i].imageUrl,
                productTitle: productsData.items[i].title,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
