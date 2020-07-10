import 'package:flutter/cupertino.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  final authToken;
  List<OrderItem> _items = [];

  Orders({this.authToken, List<OrderItem> items}){
   _items = items;
  }
  List<OrderItem> get items => [..._items];

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = 'https://flutter-shop-32501.firebaseio.com/orders.json?auth=$authToken';
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': products
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));

      _items.insert(
          0,
          OrderItem(
              id: jsonDecode(response.body)['name'],
              amount: total,
              products: products,
              dateTime: timeStamp));
      notifyListeners();
    } catch (error) {
      print('error: $error');
      throw error;
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-shop-32501.firebaseio.com/orders.json?auth=$authToken';
    try {
      final response = await http.get(url);
      print(response.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, order) {
        loadedOrders.add(OrderItem(
            id: orderId,
            amount: order['amount'],
            products: (order['products'] as List<dynamic>).map((item) =>
                CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'])).toList(),
            dateTime: DateTime.parse(order['dateTime'])));
      });
      _items = (loadedOrders);
      print(_items.length);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
