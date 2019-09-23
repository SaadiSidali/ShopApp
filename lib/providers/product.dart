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

  Future<void> toggleIsFavorite(String auth, String userId) async {
    final oldStatus = isfavorite;
    isfavorite = !isfavorite;
    notifyListeners();
    final url = 'https://fluttercourseapp.firebaseio.com/userFavorites/$userId/$id.json?auth=$auth';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isfavorite
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
