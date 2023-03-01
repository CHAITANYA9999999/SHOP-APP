import 'package:flutter/material.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String image;

  const ProductItem(
      {super.key, required this.id, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          footer: GridTileBar(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            trailing: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            leading: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
          ),
          child: GestureDetector(
            onTap: (() {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: id,
              );
            }),
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
