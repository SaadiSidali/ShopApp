import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://fluttercourseapp.firebaseio.com/orders.json';
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach(
        (ordId, order) {
          loadedOrders.add(
            OrderItem(
              id: ordId,
              amount: order['amount'],
              dateTime: DateTime.parse(order['dateTime']),
              products: (order['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      title: item['title'],
                      quantity: item['quantity'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://fluttercourseapp.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
