import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String image;

  // const ProductItem(
  //     {super.key, required this.id, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    final chosenProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    //*Consumer acts as a listener, alternate method
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                  chosenProduct.id, chosenProduct.price, chosenProduct.title);
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            chosenProduct.title,
            textAlign: TextAlign.center,
          ),

          //*By using consumer widget here, we basically shrinked the area
          //*which will re-run when the product changes
          trailing: Consumer<Product>(
            //*If there is still something which does not need to be changed,
            //*we will write that in child argument and then we can use that
            //*in builder
            child: const Text('Never Changes'),
            builder: (context, chosenProduct, child) => IconButton(
              icon: chosenProduct.isFavorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
              onPressed: () {
                chosenProduct.toggleFavouriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: (() {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: chosenProduct.id,
            );
          }),
          child: Image.network(
            chosenProduct.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
