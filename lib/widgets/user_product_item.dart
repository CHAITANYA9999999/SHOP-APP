import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_products_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  const UserProductItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.id});

  @override
  Widget build(BuildContext context) {
    final snack = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: (() {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              }),
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: (() async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .removeProduct(id);
                } catch (error) {
                  //*Error is coming cause of context in future, since this method is
                  //*async, therefore this whole function is an instance of future, and
                  //*when we press it, it is not sure whether this context is
                  //*still refering to that same context, therefore we store it
                  //*separately
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Deletion Failed')));
                  snack
                      .showSnackBar(SnackBar(content: Text('Deletion Failed')));
                }
              }),
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
