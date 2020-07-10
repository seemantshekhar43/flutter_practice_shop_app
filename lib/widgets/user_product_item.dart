import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final productId;
  final productTitle;
  final productImageUrl;
  UserProductItem({this.productId, this.productTitle, this.productImageUrl});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(productImageUrl),
      ),
      title: Text(productTitle
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
              onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: productId);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
              onPressed: () async{

                final isYes= await showDialog(context: context, builder: (context) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to delete the product?'),
                  actions: <Widget>[
                    FlatButton(child: Text('No'), onPressed: (){
                      Navigator.pop(context, false);
                    },),
                    FlatButton(child: Text('Yes'),onPressed: (){
                      Navigator.pop(context, true);
                    },)
                  ],
                ),);
                if(isYes){
                  try{
                    await Provider.of<Products>(context, listen: false).deleteProduct(productId);
                  }catch(error){
                    scaffold.showSnackBar(SnackBar(content: Text(error.toString()),));
                  }
                }



              },
            ),
          ],
        ),
      ),
    );
  }
}
