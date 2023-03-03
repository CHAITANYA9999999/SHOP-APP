import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverview extends StatefulWidget {
  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('Shop App'),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                setState(() {
                  if (value == FilterOptions.Favourites) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              itemBuilder: ((context) => [
                    PopupMenuItem(
                      child: Text('Only Favourite'),
                      value: FilterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
              icon: Icon(
                Icons.more_vert,
              ),
            ),
            Consumer<Cart>(
              builder: ((_, cart, child) {
                return Badge(
                  value: cart.itemCount.toString(),
                  child: child!,
                );
              }),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: (() {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
              ),
            )
          ],
        ),
        body: ProductsGrid(
          showFavs: _showOnlyFavourites,
        ));
  }
}
