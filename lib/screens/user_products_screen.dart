import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_products_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refrechProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refrechProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.pink,
                ),
              )
            : RefreshIndicator(
                color: Theme.of(context).primaryColor,
                onRefresh: () => _refrechProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, productsData, s) => Padding(
                    padding: EdgeInsets.all(10),
                    child: productsData.items.length == 0
                          ? Center(
                              child: Text('Wow ... such empty.'),
                            )
                          : ListView.builder(
                      itemCount: productsData.items.length,
                      itemBuilder: (ctx, i) =>  Column(
                              children: <Widget>[
                                UserProductItem(
                                  productsData.items[i].id,
                                  productsData.items[i].title,
                                  productsData.items[i].imageUrl,
                                ),
                                Divider()
                              ],
                            ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
