import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String id;
  final String title;
  ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        trailing:IconButton(icon:Icon(Icons.shopping_cart),onPressed:(){},),
        leading: IconButton(icon:Icon(Icons.favorite),onPressed:(){},),
        backgroundColor: Colors.black54,
        title: Text(title,textAlign: TextAlign.center,),
      ),
    );
  }
}
