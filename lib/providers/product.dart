import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfavorite;

  Future<void> toggleIsFavorite() async {
    final oldStatus = isfavorite;
    isfavorite = !isfavorite;
    notifyListeners();
    final url = 'https://fluttercourseapp.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {'isFavorite': isfavorite},
        ),
      );
      if (response.statusCode >= 400) throw HttpException('OOps');
    } catch (error) {
      isfavorite = oldStatus;
    }
  }

  Product({
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    this.isfavorite = false,
  });
}
