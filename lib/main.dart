import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //*If the context does not matter to you, you could simply just use
    //*ChangeNotifierProvider.value
    // return ChangeNotifierProvider(
    return ChangeNotifierProvider.value(
      //*Only things that are listening to this class will be rebuild when
      //*notifyListener is called from that class, i.e. here the whole
      //*MaterialApp will not be rebuild
      // create: (ctx) => Products(),

      value: Products(),

      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverview(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        },
      ),
    );
  }
}
