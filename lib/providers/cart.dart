import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/widgets/cart_item.dart';

class SingleCartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  SingleCartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, SingleCartItem> _items = {};

  Map<String, SingleCartItem> get items {
    return {..._items};
  }

  int get itemCount {
    var count = 0;
    _items.forEach((key, value) {
      count += value.quantity;
    });
    return count;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void addItem(
    String productId,
    double productPrice,
    String productTitle,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => SingleCartItem(
                id: value.id,
                title: value.title,
                quantity: value.quantity + 1,
                price: value.price,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => SingleCartItem(
              id: DateTime.now().toString(),
              title: productTitle,
              quantity: 1,
              price: productPrice));
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void removeSingleCartItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (value) => SingleCartItem(
              id: value.id,
              price: value.price,
              quantity: value.quantity - 1,
              title: value.title));
    } else {
      removeItem(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
