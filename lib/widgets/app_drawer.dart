import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/screens/order_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';
import 'package:shopapp/screens/welcome_screen.dart';

class AppDrawer extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(title: Text(
            'Hello Friend'
          ),
          automaticallyImplyLeading: false,),
          
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: (){
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: (){
              Navigator.pushReplacementNamed(context, OrderScreen.routeName);
            },

          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.pushReplacementNamed(context, UserProductScreen.routeName);
            },

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){

              Provider.of<Auth>(context, listen: false).logOut();
              Navigator.pushReplacementNamed(context, '/');
            },

          )
        ],
      ),
    );
  }
}
