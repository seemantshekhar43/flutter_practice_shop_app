import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/login_screen.dart';
import 'package:shopapp/screens/order_screen.dart';
import 'package:shopapp/screens/product_detail.dart';
import 'package:shopapp/screens/product_overview_screen.dart';
import 'package:shopapp/screens/signup_screen.dart';
import 'package:shopapp/screens/splash_screen.dart';
import 'package:shopapp/screens/user_product_screen.dart';
import 'package:shopapp/screens/welcome_screen.dart';

import 'providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),

        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) =>
              Products(authToken: null, userId: null, items: []),
          update: (BuildContext context, auth, Products previous) => Products(
              authToken: auth.token,
              userId: auth.userId,
              items: previous.items),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (context) => Cart(authToken: null, items: {}),
          update: (context, auth, previous) =>
              Cart(authToken: auth.token, items: previous.items),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(authToken: null, items: []),
          update: (context, auth, previous) =>
              Orders(authToken: auth.token, items: previous.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.purple,
            accentColor: Colors.orange,
          ),
          home: auth.isAuth
              ? ProductOverViewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : WelcomeScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            SignUpScreen.routeName: (context) => SignUpScreen(),
            ProductOverViewScreen.routeName: (context) =>
                ProductOverViewScreen(),
          },
        ),
      ),
    );
  }
}
