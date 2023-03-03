import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/Orders-Screen';
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allOrders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Your Orders!')),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return OrderItem(order: allOrders.orders[index]);
        }),
        itemCount: allOrders.totalOrders,
      ),
    );
  }
}
