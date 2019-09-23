import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with SingleTickerProviderStateMixin {
  var _expanded = false;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacity;

  @override
  void initState() {
    
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn));
    _opacity = Tween<double>(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: _controller,curve: Curves.easeIn),);
    _controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
          child: SlideTransition(
        position: _slideAnimation,
            child: Card(
          margin: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('\$${widget.order.amount}'),
                subtitle: Text(
                  DateFormat('dd MMM yyyy hh:mm').format(widget.order.dateTime),
                ),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ),
              
                AnimatedContainer(
                  //  height: _authMode == AuthMode.Signup ? 320 : 260,
        // constraints: BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
                  duration: Duration(milliseconds: 150),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                  height: _expanded? min(widget.order.products.length * 20.0 + 20, 150.0):0,
                  child: ListView(
                    children: widget.order.products
                        .map(
                          (product) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${product.quantity}x \$${product.price}',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
