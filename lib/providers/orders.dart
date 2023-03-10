import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/widgets/cart_item.dart';
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

  Future<void> addOrder(List<SingleCartItem> cartProducts, double total) async {
    final date = DateTime.now();
    final url = Uri.parse(
        'https://flutter-backend-335b1-default-rtdb.firebaseio.com/orders.json');
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'products': cartProducts.map((e) {
            return {
              'id': e.id,
              'title': e.title,
              'price': e.price,
              'quantity': e.quantity
            };
          }).toList(),
          'dateTime': date.toIso8601String()
        }));

    _orders.insert(
        0,
        SingleOrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: date));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://flutter-backend-335b1-default-rtdb.firebaseio.com/orders.json');
    var response = await http.get(url);
    print(json.decode(response.body));

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    } else {
      List<SingleOrderItem> extractedOrders = [];
      extractedData.forEach((key, value) {
        extractedOrders.add(SingleOrderItem(
            id: key,
            amount: value['amount'],
            products: (value['products'] as List<dynamic>)
                .map((e) => SingleCartItem(
                      id: e['id'],
                      price: e['price'],
                      quantity: e['quantity'],
                      title: e['title'],
                    ))
                .toList(),
            dateTime: DateTime.parse(value['dateTime'])));
      });
      _orders = extractedOrders.reversed.toList();
      notifyListeners();
    }
  }
}
