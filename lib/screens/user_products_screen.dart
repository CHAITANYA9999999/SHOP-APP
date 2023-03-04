import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_products_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/User-Products-Screen';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: (() {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: ((_, index) {
            return Column(
              children: [
                UserProductItem(
                  title: productsData.items[index].title,
                  imageUrl: productsData.items[index].imageUrl,
                ),
                Divider(),
              ],
            );
          }),
          itemCount: productsData.items.length,
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final productsData = Provider.of<Products>(context);
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Your Products'),
  //       actions: [
  //         IconButton(
  //           onPressed: (() {}),
  //           icon: Icon(Icons.add),
  //         ),
  //       ],
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(8),
  //       child: ListView.builder(
  //         itemBuilder: ((_, index) {
  //           return UserProductItem(
  //             title: productsData.items[index].title,
  //             imageUrl: productsData.items[index].imageUrl,
  //           );
  //         }),
  //         itemCount: productsData.items.length,
  //       ),
  //     ),
  //   );
}
