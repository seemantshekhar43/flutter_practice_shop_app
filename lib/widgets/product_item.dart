import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/product_detail.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageUrl;
//
//  ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {

    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, ProductDetailScreen.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(
                product.isFavorite? Icons.favorite: Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () async{
                try{

                  await product.toggleFavoriteStatus(authData.token, authData.userId);
                }catch(error){
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString(), textAlign: TextAlign.center,),

                  ));
                }

              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added item to cart'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: (){
                    cart.removeSingleItem(product.id);
                  },
                ),
              ),);
            },
          ),
        ),
      ),
    );
  }
}
