import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart' show Orders;
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {

  static const routeName = '/orderScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
       future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, dataSnapshot){
         if(dataSnapshot.connectionState == ConnectionState.waiting){
           return Center(child: CircularProgressIndicator());
         }else if(dataSnapshot.hasError){
           return Center(child: Text('Error loading data'),);
         }else{
           return Consumer<Orders>(
             builder: (context, orderData, child) => ListView.builder(
                 itemCount: orderData.items.length,
                 itemBuilder: (context, i) => OrderItem(
                   order: orderData.items[i],
                 )),
           );
         }
          },
      )
    );
  }
}
