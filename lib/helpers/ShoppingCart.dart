import 'package:dinas/models/CartItem.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:dinas/models/AppState.dart';

class ShoppingCart{

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount{
    return _items.length;
  }

  double get totalAmount{
    var total = 0.0;
    _items.forEach((key, cart) => total += cart.price * cart.quantity);
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (old) => CartItem(
          id: old.id,
          title: old.title,
          price: old.price,
          quantity: old.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () => CartItem(id: '', title: title, price: price, quantity: 1),
      );
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
              (old) => CartItem(
              id: old.id,
              title: old.title,
              price: old.price,
              quantity: old.quantity - 1));
    }
  }

  void clear() {
    _items = {};
  }
}