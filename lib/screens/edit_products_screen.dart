import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProducted =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit == true) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProducted = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'title': _editedProducted.title,
          'description': _editedProducted.description,
          'price': _editedProducted.price.toString(),
          // 'imageUrl': _editedProducted.imageUrl,
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProducted.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //*Since focusNode gets saves in the memory, so there is a chance of
  //*memory leaks, therefore we need to dispose the node
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    //*We needed to interact with the Form in order to save the data, so
    //*we used a global key and provided it to the form and that key is
    //*of the type FormState, now we can access the form

    //*First when this function is triggered, it will run validate(), and
    //*that will check whether all the validators in the form have returned true
    bool? _isValid = _form.currentState?.validate();
    print(_isValid);
    if (_isValid == false) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });
    if (_editedProducted.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProducted, _editedProducted.id);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProducted);
      } catch (error) {
        //*To check this part, remove .json from url
        await showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                // title: Text('An error occured'),
                title: Text('Something went wrong'),
                content: Text(error.toString()),
                actions: [
                  TextButton(
                    onPressed: (() {
                      Navigator.of(context).pop();
                    }),
                    child: Text('Okay'),
                  )
                ],
              );
            }));
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //     Navigator.of(context).pop();
      //   });
      // }
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
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                //*provided a key so that we can access it outside the form
                key: _form,

                child: ListView(
                  children: [
                    Column(children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter Title',
                          // errorText: 'jgbhk',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (newValue) {
                          _editedProducted = Product(
                            id: _editedProducted.id,
                            title: newValue.toString(),
                            description: _editedProducted.description,
                            price: _editedProducted.price,
                            imageUrl: _editedProducted.imageUrl,
                            isFavorite: _editedProducted.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value?.length == 0) {
                            return 'Please enter a Title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'Enter Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (newValue) {
                          _editedProducted = Product(
                            id: _editedProducted.id,
                            title: _editedProducted.title,
                            description: _editedProducted.description,
                            price: double.parse(newValue!),
                            imageUrl: _editedProducted.imageUrl,
                            isFavorite: _editedProducted.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value?.length == 0) {
                            return 'Please enter a Price';
                          }
                          if (double.tryParse(value!) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            hintText: 'Enter Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (newValue) {
                          _editedProducted = Product(
                            id: _editedProducted.id,
                            title: _editedProducted.title,
                            description: newValue.toString(),
                            price: _editedProducted.price,
                            imageUrl: _editedProducted.imageUrl,
                            isFavorite: _editedProducted.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value?.length == 0) {
                            return 'Please enter a valid Description';
                          }
                          if (value!.length <= 10) {
                            return 'Should be atleast 10 characters long';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        //*You cannot set initial value as well as controller
                        //*together, therefore we gave that value to the controller itself
                        // initialValue: _initValues['imageUrl'],
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: (() {
                          setState(() {});
                        }),
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: ((_) {
                          _saveForm();
                        }),
                        onSaved: (newValue) {
                          _editedProducted = Product(
                            id: _editedProducted.id,
                            title: _editedProducted.title,
                            description: _editedProducted.description,
                            price: _editedProducted.price,
                            imageUrl: newValue!,
                            isFavorite: _editedProducted.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value?.length == 0) {
                            return 'Please enter an image URL';
                          }

                          if (!(value!.startsWith('http://') ||
                              value.startsWith('https://'))) {
                            return 'Please enter a valid URL';
                          }

                          if (!(value.endsWith('.png') ||
                              value.endsWith('.jpg') ||
                              value.endsWith('.jpeg'))) {
                            return 'Please enter a valid image URL';
                          }
                          return null;
                        },
                      ),

                      _imageUrlController.text.isEmpty
                          ? Container()
                          : Container(
                              margin: const EdgeInsets.only(top: 8, right: 10),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              )),
                              child: FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                ),
                                fit: BoxFit.contain,
                              )),

                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Container(
                      //         margin: EdgeInsets.only(top: 8, right: 10),
                      //         width: 100,
                      //         height: 100,
                      //         decoration: BoxDecoration(
                      //             border: Border.all(
                      //           width: 1,
                      //           color: Colors.grey,
                      //         )),
                      //         child: _imageUrlController.text.isEmpty
                      //             ? Text('Enter a URL')
                      //             : FittedBox(
                      //                 child: Image.network(
                      //                   _imageUrlController.text,
                      //                 ),
                      //                 fit: BoxFit.cover,
                      //               )),
                      //     Expanded(
                      //       child: TextFormField(
                      //         decoration: InputDecoration(labelText: 'Image URL'),
                      //         keyboardType: TextInputType.url,
                      //         textInputAction: TextInputAction.done,
                      //         controller: _imageUrlController,
                      //         onEditingComplete: (() {
                      //           setState(() {});
                      //         }),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ]),
                  ],
                ),
              ),
            ),
    );
  }
}
