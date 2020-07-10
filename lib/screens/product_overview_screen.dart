import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/badge.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/products_grid.dart';

enum FilterOption{
  all,
  favorite
}
class ProductOverViewScreen extends StatefulWidget {

  static const routeName = '/product-over-view';

  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {

  var _showFavoritesOnly = false;
  var _isInit = true;
  var _isLoading = false;


  @override
  void didChangeDependencies() {

    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_){
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOption option){
              setState(() {

              if(option == FilterOption.favorite)
              _showFavoritesOnly = true;
              else
                _showFavoritesOnly = false;
              });
            },
            icon: Icon(
              Icons.more_vert
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                  value: FilterOption.favorite,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOption.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) =>Badge(
              child: ch,
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator(),): ProductsGrid(showFavoritesOnly: _showFavoritesOnly),
    );
  }
}

