import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/http_exception_.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
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

  Future<void> removeProduct(String productId) async {
    final url = Uri.parse(
        'https://flutter-backend-335b1-default-rtdb.firebaseio.com/products/$productId.json');
    final existingProductIndex =
        _items.indexWhere((element) => productId == element.id);
    Product? existingProduct = _items[existingProductIndex];
    // _items.removeWhere((element) => element.id == productId);
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url).then((value) {
      //*catchError was not working if we remove the .json in the end
      //*therefore we created our custom exception
      if (value.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct!);
        notifyListeners();
        throw HttpException('Could not delete product.');
      }
      existingProduct = null;
    });
  }

  // Future<void> addProduct(Product product) {
  //   //*Add /products.json in the end
  //   final url = Uri.parse(
  //       'https://flutter-backend-335b1-default-rtdb.firebaseio.com/products.json');
  //   //*JSON = JAVASCRIPT OBJECT NOTATION
  //   //* We cannot simply pass product in the body because it is a dart
  //   //*object and we need to pass a json object
  //   // http.post(url,body: product);
  //   //*This only sends the request to upload data to the server, it does
  //   //*recieve whether this process was successful or not, it just sends the
  //   //* the request and move on to the next line of code. This type is called
  //   //*asynchronous, but when we add then it is no longer asynchronous
  //   //*It will return the future of.then, i.e., .then of the .then of the post
  //   return http
  //       .post(url,
  //           body: json.encode({
  //             'title': product.title,
  //             'description': product.description,
  //             'price': product.price,
  //             'imageUrl': product.imageUrl,
  //             'isFavorite': product.isFavorite,
  //           }))
  //       .then((value) {
  //     //*Then function will run when the above process is completed
  //     print(json.decode(value.body));
  //     final newProduct = Product(
  //       id: json.decode(value.body)['name'],
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl: product.imageUrl,
  //     );
  //     _items.add(newProduct);
  //     notifyListeners();
  //   }).catchError((error) {
  //     //*It will run if error is thrown either by post or .then block
  //     throw error;
  //   });
  // }

  //*A more better way to deal with future and stuff
  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-backend-335b1-default-rtdb.firebaseio.com/products.json');
    try {
      //*await automatically returns a future
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product product, String id) async {
    final prodIndex = _items.indexWhere((element) => product.id == id);
    if (prodIndex >= 0) {
      //*We do not need to target all the products but only the one we are
      //*updating
      final url = Uri.parse(
          'https://flutter-backend-335b1-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(
        url,
        body: json.encode(
          {
            //*Only these 4 fields could be change while editing a product
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );
      _items[prodIndex] = product;
    }
    notifyListeners();
  }

  Future<void> fetchProduct() async {
    final url = Uri.parse(
        'https://flutter-backend-335b1-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      } else {
        List<Product> extractedProducts = [];
        extractedData.forEach((prodId, prodData) {
          extractedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ));
        });
        _items = extractedProducts;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }
}
