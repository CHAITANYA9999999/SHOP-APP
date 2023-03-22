import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavouriteStatus(String authToken, String userId) async {
    final url = Uri.parse(
        'https://flutter-backend-335b1-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken');
    await http.put(
      url,
      body: json.encode(
        {
          //*Only these 4 fields could be change while editing a product
          'isFavorite': !isFavorite,
        },
      ),
    );
    isFavorite = !isFavorite;

    //*It act as a setState
    notifyListeners();
  }
}
