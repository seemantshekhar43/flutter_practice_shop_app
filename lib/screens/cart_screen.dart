import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart' show Cart;
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                  ),
                   OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (context, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);


  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
           child: (_isLoading)
               ? CircularProgressIndicator()
               :Text(
             "ORDER NOW",
             style: TextStyle(
               color: Theme.of(context).primaryColor,
             ),
           ),
           onPressed: widget.cart.totalAmount <= 0 || _isLoading
               ? null
               : () async{
                   try {
                     setState(() {
                       _isLoading = true;
                     });

                     await Provider.of<Orders>(context, listen: false)
                         .addOrder(widget.cart.items.values.toList(),
                             widget.cart.totalAmount);
                       setState(() {
                         _isLoading = false;
                       });

                       widget.cart.clear();

                   } catch (error) {
                     print(error);
                     setState(() {
                       _isLoading = false;
                     });
                   }
                 },
         );
  }
}
