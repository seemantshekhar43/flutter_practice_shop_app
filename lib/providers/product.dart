import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopapp/models/http_exception.dart';

class Product extends ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String authToken, String userId) async{
    final url = 'https://flutter-shop-32501.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    isFavorite = !isFavorite;
    notifyListeners();
    try{
      final response = await http.put(url,body: jsonEncode(
        isFavorite));
      if(response.statusCode >= 400){
        isFavorite = !isFavorite;
        notifyListeners();
        throw HttpException(message: 'Adding to favorite failed');
      }
    }
   catch(error){
//      isFavorite = !isFavorite;
//      print(error);
//      notifyListeners();
//     throw HttpException(message: 'Adding to favorite failed');
    }
  
  }
}
