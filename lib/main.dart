import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/user_products_screen.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import 'providers/products.dart';
import 'screens/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //*If the context does not matter to you, you could simply just use
    //*ChangeNotifierProvider.value
    // return ChangeNotifierProvider(
    // return ChangeNotifierProvider.value(
    //*Only things that are listening to this class will be rebuild when
    //*notifyListener is called from that class, i.e. here the whole
    //*MaterialApp will not be rebuild
    // create: (ctx) => Products(),
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((_) => Auth())),

          //*It is a provider which dependent on another provider
          // ChangeNotifierProvider(create: (_) => Products(Provider.of<Auth>(context).token as String)),
          ChangeNotifierProxyProvider<Auth, Products>(
              //*it will create
              create: (ctx) => Products('', [], ''),
              //*It will update
              update: ((context, auth, previousProducts) {
                return (auth.token == null)
                    ? Products('', [], '')
                    : Products(
                        auth.token!,
                        previousProducts == null ? [] : previousProducts.items,
                        auth.userId!);
              })),

          ChangeNotifierProvider(create: (_) => Cart()),

          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (_) => Orders('', [], ''),
              update: ((context, auth, previousOrders) {
                return Orders(
                    auth.token!,
                    previousOrders == null ? [] : previousOrders.orders,
                    auth.userId!);
              }))
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) {
            // print(auth.isAuth);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth == true
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (context) =>
                    ProductDetailScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrderScreen.routeName: (context) => OrderScreen(),
                UserProductsScreen.routeName: (context) => UserProductsScreen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
                AuthScreen.routeName: (context) => AuthScreen(),
                ProductOverviewScreen.routeName: (context) =>
                    ProductOverviewScreen(),
              },
            );
          },
        ));
  }
}
