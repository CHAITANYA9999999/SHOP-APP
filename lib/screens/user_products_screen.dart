import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_products_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/User-Products-Screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: (() {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: (() => _refreshProducts(context)),
                  child: Consumer<Products>(
                    builder: ((context, productsData, _) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: ((_, index) {
                            return Column(
                              children: [
                                UserProductItem(
                                  title: productsData.items[index].title,
                                  imageUrl: productsData.items[index].imageUrl,
                                  id: productsData.items[index].id,
                                ),
                                const Divider(),
                              ],
                            );
                          }),
                          itemCount: productsData.items.length,
                        ),
                      );
                    }),
                  ));
        },
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
