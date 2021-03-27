import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(
      context,
    ).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return ChangeNotifierProvider.value(
              value: product[index],
              child: UserProductItem(),
            );
          },
          itemCount: product.length,
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
