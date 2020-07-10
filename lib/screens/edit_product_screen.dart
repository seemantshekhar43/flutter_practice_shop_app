import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product_form.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isInit = true;
  bool _isLoading = false;
  ProductForm _productForm = ProductForm();

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        Product product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _productForm.id = product.id;
        _productForm.title = product.title;
        _productForm.price = product.price;
        _productForm.description = product.description;
        _productForm.imageUrl = product.imageUrl;
        _productForm.isFavorite = product.isFavorite;
        _imageUrlController.text = _productForm.imageUrl;
        _isInit = false;
      }
    }
  }

  @override
  void dispose() {
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlController.removeListener(_updateImage);
    super.dispose();
  }

  void _updateImage() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_productForm.id == null) {
      final Product product = Product(
          id: null,
          title: _productForm.title,
          description: _productForm.description,
          price: _productForm.price,
          imageUrl: _productForm.imageUrl);
      try {
        await Provider.of<Products>(context, listen: false).addProduct(product);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('An error occurred'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OKAY'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );
      }
//       finally {
//        setState(() {
//          _isLoading = false;
//        });
//        Navigator.pop(context);
//      }
    } else {
      final Product product = Product(
          id: _productForm.id,
          title: _productForm.title,
          description: _productForm.description,
          price: _productForm.price,
          imageUrl: _productForm.imageUrl,
          isFavorite: _productForm.isFavorite);
      try {
        await Provider.of<Products>(context, listen: false).updateProduct(
            product);
      }catch (error) {
        await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('An error occurred'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OKAY'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: TextFormField(
                        initialValue: _productForm.title,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onSaved: (value) {
                          _productForm.title = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Title can\'t be empty';
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: TextFormField(
                        initialValue: (_productForm.price != null)
                            ? _productForm.price.toString()
                            : '',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.datetime,
                        focusNode: _priceFocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        decoration: InputDecoration(

                          filled: true,
                          fillColor: Color(0xffE1E2E1),
                          labelText: 'Price',
                          hintText: 'Enter price',
border: InputBorder.none,
suffix: GestureDetector(child: Icon(Icons.date_range), onTap: (){
                        showDialog(context: context, builder: (context) => AlertDialog(content: Text('random'),));
                        },),




//                          border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(5.0),
//                          ),
                        ),
                        onSaved: (value) {
                          _productForm.price = double.parse(value);
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter price';
                          else if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          } else if (double.parse(value) <= 0)
                            return 'Please enter a value greater than 0.';
                          else
                            return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: TextFormField(
                        initialValue: _productForm.description,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocus,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter short description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onSaved: (value) {
                          _productForm.description = value;
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please enter a description';
                          else if (value.length < 10)
                            return 'Please enter a description of at least 10 characters.';
                          else
                            return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100.0,
                            height: 100.0,
                            margin: EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.0, color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter Image Url')
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Image.network(
                                          _imageUrlController.text),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.url,
                              focusNode: _imageUrlFocus,
                              controller: _imageUrlController,
                              decoration: InputDecoration(
                                labelText: 'Image Url',
                                hintText: 'Enter image url',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onSaved: (value) {
                                _productForm.imageUrl = value;
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please enter an image url';
                                else if (!value.startsWith('http') &&
                                    !value.startsWith('https'))
                                  return 'Please enter a valid url';
                                else
                                  return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
