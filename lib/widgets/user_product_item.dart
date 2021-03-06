import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );

    return Column(
      children: [
        ListTile(
          title: Text(product.title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              product.imageUrl,
            ),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.routeName,
                      arguments: product.id,
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<Products>(context, listen: false).deleteProduct(
                      product.id,
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
