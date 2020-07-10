import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItem extends StatelessWidget {
  final id;
  final price;
  final quantity;
  final title;
  final productId;


  CartItem({this.id, this.productId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, size: 40.0, color: Colors.white,),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 15.0),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (context) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to remove the item from cart?'),
          actions: <Widget>[
            FlatButton(child: Text('No'), onPressed: (){
              Navigator.pop(context, false);
            },),
            FlatButton(child: Text('Yes'),onPressed: (){
              Navigator.pop(context, true);   
            },)
          ],
        ),);
      },
      onDismissed: (direction){
        Provider.of<Cart>(context, listen:false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('\$$price', style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6.color,
                  ),),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
