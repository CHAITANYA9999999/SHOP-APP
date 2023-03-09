import 'dart:convert';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  var _showFavouritesOnly = false;

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((element) {
    //     return element.isFavorite;
    //   }).toList();
    // }
    return [..._items];
  }

  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere(((element) {
      return element.id == id;
    }));
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  void removeProduct(String productId) {
    _items.removeWhere((element) => element.id == productId);
    notifyListeners();
  }

  Future<void> addProduct(Product product) {
    //*Add /products.json in the end
    final url = Uri.parse(
        'https://flutter-backend-335b1-default-rtdb.firebaseio.com/products.json');
    //*JSON = JAVASCRIPT OBJECT NOTATION
    //* We cannot simply pass product in the body because it is a dart
    //*object and we need to pass a json object
    // http.post(url,body: product);
    //*This only sends the request to upload data to the server, it does
    //*recieve whether this process was successful or not, it just sends the
    //* the request and move on to the next line of code. This type is called
    //*asynchronous, but when we add then it is no longer asynchronous
    //*It will return the future of.then, i.e., .then of the .then of the post
    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavorite,
            }))
        .then((value) {
      //*Then function will run when the above process is completed
      print(json.decode(value.body));
      final newProduct = Product(
        id: json.decode(value.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      //*It will run if error is thrown either by post or .then block
      throw error;
    });
  }

  void updateProduct(Product product, String id) {
    final prodIndex = _items.indexWhere((element) => product.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = product;
    }
    notifyListeners();
  }
}
