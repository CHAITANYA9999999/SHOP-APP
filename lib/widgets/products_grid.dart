import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid({super.key, required this.showFavs});
  // final List<Product> loadedProducts;
  // const ProductsGrid({super.key, required this.loadedProducts});

  @override
  Widget build(BuildContext context) {
    //*We set up a listener here for the provider in main.dart, we wrote products in <> so as to know
    //*which listener is it, i.e., here it will listen when something in the products class will change
    final productsData = Provider.of<Products>(context);

    //*Now we can access the methods in the products class, here we used the getter function defined in the
    //*products class
    final products =
        showFavs ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(),
            // id: products[index].id,
            // title: products[index].title,
            // image: products[index].imageUrl,
            // ),
          )),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
