import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int amount;
  CartItem(this.id, this.productId, this.title, this.price, this.amount);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure ?'),
                  content: Text(
                    'Do you want to remove the item from the cart?',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'No',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    )
                  ],
                ));
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        padding: EdgeInsets.only(
          right: 15,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 40,
        ),
      ),
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$$price')),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(amount * price)}'),
            trailing: Text('$amount x'),
          ),
        ),
      ),
    );
  }
}
