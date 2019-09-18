import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initvalues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _initvalues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false).addProduct(
          _editedProduct,
        );
      } catch (error) {
        print('THIS IS THE FKN ERROR MATE' + error.toString());

        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Oh no! 😯'),
                  content: Text(
                    'Something went wrong! 📌',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      textColor: Colors.pink,
                      child: Text(
                        'Okay',
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: Colors.pink,
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initvalues['title'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a title.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: value,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isfavorite: _editedProduct.isfavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initvalues['price'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price.';
                          }
                          if (double.parse(value) < 0) {
                            return 'Please enter a positive price.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: double.parse(value),
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isfavorite: _editedProduct.isfavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initvalues['description'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Description is empty.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: value,
                              imageUrl: _editedProduct.imageUrl,
                              id: _editedProduct.id,
                              isfavorite: _editedProduct.isfavorite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please add an Image Url.';
                                }
                                if (!value.startsWith('http') && !value.startsWith('https')) {
                                  return 'Please enter a valid url';
                                }
                                return null;
                              },
                              focusNode: _imageFocusNode,
                              decoration: InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onSaved: (value) {
                                _editedProduct = Product(
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  description: _editedProduct.description,
                                  imageUrl: value,
                                  id: _editedProduct.id,
                                  isfavorite: _editedProduct.isfavorite,
                                );
                              },
                              onFieldSubmitted: (_) => _saveForm(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
