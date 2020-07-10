import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {

    final productID = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(productID);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300.0,
            width: double.infinity,
            child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover,),
          ),
          SizedBox(height: 10.0,),
          ListTile(
            title: Text(loadedProduct.title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),),
            subtitle: Text(loadedProduct.description, softWrap: true,),
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              Provider.of<Cart>(context, listen: false).addItem(loadedProduct.id, loadedProduct.price, loadedProduct.title);
            },
            child: Container(height: 70.0,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: (Text('Add to Cart'.toUpperCase(), style: TextStyle(

                color: Theme.of(context).primaryTextTheme.headline6.color,
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),)),
            ),),
          )
        ],
      ),
    );
  }
}
