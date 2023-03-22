import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../providers/product.dart';
import '../widgets/products_grid.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview-screen';
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    //*Providers and modal routes dont work in init state as the widget
    //*has not been build completely, if we set listen: false, we can use
    // Provider.of<Products>(context).fetchProduct();

    //*since it is a future, it will mark this as to-do, it will work but
    //*it will prioritise it differently, so no
    // Future.delayed(Duration.zero)
    //     .then((value) => Provider.of<Products>(context).fetchProduct());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    //*It will run when the widget is fully initialised but before the
    //*build ran, this will run many time therefore we use a helper variable
    //*like isInit
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // void changeFav(Product product) {
  //   _isLoading = true;
  //   Provider.of<Product>(context).toggleFavouriteStatus().then((value) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(
                showFavs: _showOnlyFavourites,
              ));
  }
}
