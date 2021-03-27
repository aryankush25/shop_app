import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
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
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {},
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
