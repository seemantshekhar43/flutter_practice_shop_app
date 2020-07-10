import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopapp/providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle:
                Text(DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_isExpanded? Icons.expand_less: Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if(_isExpanded) Container(
            height: min(widget.order.products.length * 80.0, 200.0),
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: ListView(
              children: widget.order.products.map((e) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text('\$${e.price}', style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.headline6.color,
                      ),),
                    ),
                  ),
                ),
                title: Text(e.title),
                subtitle: Text('Total: ${(e.price * e.quantity).toStringAsFixed(2)}'),
                trailing: Text('${e.quantity}x'),
              ),).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
