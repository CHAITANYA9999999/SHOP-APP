import 'package:flutter/cupertino.dart';

import 'cart.dart';

class SingleOrderItem {
  final String id;
  final double amount;
  final List<SingleCartItem> products;
  final DateTime dateTime;

  SingleOrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<SingleOrderItem> _orders = [];

  List<SingleOrderItem> get orders {
    return [..._orders];
  }

  int get totalOrders {
    return _orders.length;
  }

  void addOrder(List<SingleCartItem> cartProducts, double total) {
    _orders.insert(
        0,
        SingleOrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartProducts,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
