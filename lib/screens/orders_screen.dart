import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order_screen';

  //*ONE MORE WAY OF DOING THIS WITHOUT CONVERTING IT TO A STATEFUL WIDGET
  // var _isLoading = false;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   _isLoading = true;
  //   Provider.of<Orders>(context, listen: false).fetchOrders().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final allOrders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Your Orders!')),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error == null) {
                return Consumer<Orders>(
                    builder: ((context, orderData, child) => ListView.builder(
                          itemBuilder: ((context, index) {
                            return OrderItem(order: orderData.orders[index]);
                          }),
                          itemCount: orderData.totalOrders,
                        )));
              }
            }
            return Container();
          }),
    );
  }
}
