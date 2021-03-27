import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String _title = '';
  double _price = 0;
  String _description = '';
  String _imageUrl = '';

  var _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isInit = true;
      final productid = ModalRoute.of(context).settings.arguments as String;

      if (productid != null && productid.isNotEmpty) {
        final product = Provider.of<Products>(context, listen: false).findById(
          productid,
        );

        _title = product.title;
        _price = product.price;
        _description = product.description;
        _imageUrl = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
      }
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formkey.currentState.validate();

    if (isValid) {
      _formkey.currentState.save();
      final productsProvider = Provider.of<Products>(context, listen: false);
      final productid = ModalRoute.of(context).settings.arguments as String;

      if (productid != null && productid.isNotEmpty) {
        final product = productsProvider.findById(
          productid,
        );

        var _editedProduct = Product(
          id: productid,
          title: _title,
          description: _description,
          imageUrl: _imageUrl,
          price: _price,
          isFavourite: product.isFavourite,
        );

        productsProvider.updateProduct(_editedProduct);
      } else {
        var _editedProduct = Product(
          id: DateTime.now().toString(),
          title: _title,
          description: _description,
          imageUrl: _imageUrl,
          price: _price,
        );

        productsProvider.addProduct(_editedProduct);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    // _priceFocusNode.requestFocus();
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _title = value;
                  },
                  validator: (value) {
                    if (value.length < 2) {
                      return 'This is wrong!';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _price.toString(),
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onSaved: (value) {
                    _price = double.parse(value);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a value!';
                    }

                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    _description = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'This is wrong!';
                    }

                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL!')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onSaved: (value) {
                          _imageUrl = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This is wrong!';
                          }

                          return null;
                        },
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
