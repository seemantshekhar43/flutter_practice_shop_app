import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      this.quantity = 1,
      @required this.price});
}

class Cart extends ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => {..._items};
  final authToken;
  Cart({this.authToken, Map<String, CartItem> items}){
    _items = items;
}

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingValue) => CartItem(
                id: existingValue.id,
                price: existingValue.price,
                title: existingValue.title,
                quantity: existingValue.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(), title: title, price: price));
    }

    notifyListeners();
  }

  int get itemsCount => _items.length;

  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void removeItem(id){
    _items.remove(id);
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(id){
    if(!_items.containsKey(id))
      return;
    if(_items[id].quantity > 1)
      _items.update(
          id,
              (existingValue) => CartItem(
            id: existingValue.id,
            price: existingValue.price,
            title: existingValue.title,
            quantity: existingValue.quantity -1,
          ));
    else
      _items.remove(id);

    notifyListeners();
  }
}
