import 'package:flutter/foundation.dart';
import 'package:shopapp/models/http_exception.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//        id: 'p1',
//        title: 'Red Shirt',
//        description: 'A red shirt- it is pretty red!',
//        price: 20.99,
//        imageUrl:
//            'https://cdn.pixabay.com/photo/2020/05/25/03/28/beard-5216821__340.jpg'),
//    Product(
//        id: 'p2',
//        title: 'Blue Shirt',
//        description:
//            'Blue shirt - color is like of sky! How you doing, this is a demo text just to represent a soft wrap text, i want to check whe'
//            'it soft breaks or not in screen',
//        price: 20.99,
//        imageUrl:
//            'https://cdn.pixabay.com/photo/2012/04/26/14/33/t-shirt-42654__340.png'),
//    Product(
//        id: 'p3',
//        title: 'Green Shirt',
//        description: 'Olive Green T-shirt!',
//        price: 20.99,
//        imageUrl:
//            'https://cdn.pixabay.com/photo/2017/01/13/04/28/blank-1976317__340.png'),
//    Product(
//        id: 'p4',
//        title: 'White Shirt',
//        description: 'A white shirt resembles peace.',
//        price: 20.99,
//        imageUrl:
//            'https://cdn.pixabay.com/photo/2015/09/06/01/03/white-926838__340.jpg'),
  ];

  final String authToken;
  final String userId;
  Products({this.authToken, this.userId, List<Product> items}) {
    _items = items;
  }
  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      [..._items.where((element) => element.isFavorite == true).toList()];
  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shop-32501.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));

      _items.add(Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl));
      notifyListeners();
    } catch (error) {
      print('error: $error');
      throw error;
    }
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://flutter-shop-32501.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      print(response.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null)
        return;

      final favoriteUrl = 'https://flutter-shop-32501.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

      final favoriteResponse = await http.get(favoriteUrl);
      final favoriteData =  json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, product) {
        loadedProducts.add(Product(
            id: productId,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            isFavorite: favoriteData == null? false:favoriteData[productId] ?? false));
      });
      _items = (loadedProducts);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final url =
        'https://flutter-shop-32501.firebaseio.com/products/${product.id}.json';

    await http.patch(url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }));
    final index = _items.indexWhere((prod) => prod.id == product.id);
    _items[index] = product;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-shop-32501.firebaseio.com/products/$id.json';

    final existingIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, existingProduct);
      notifyListeners();
      throw HttpException(message: 'Deleting product failed');
    }
  }
}
