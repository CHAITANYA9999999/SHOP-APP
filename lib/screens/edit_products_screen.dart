import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  //*Since focusNode gets saves in the memory, so there is a chance of
  //*memory leaks, therefore we need to dispose the node
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              Column(children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Title', hintText: 'Enter Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Price', hintText: 'Enter Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) => FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Description', hintText: 'Enter Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 8, right: 10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        )),
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter a URL')
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                ),
                                fit: BoxFit.cover,
                              )),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: (() {
                          setState(() {});
                        }),
                      ),
                    ),
                  ],
                ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Image URL'),
                //   keyboardType: TextInputType.url,
                //   textInputAction: TextInputAction.done,
                //   controller: _imageUrlController,
                //   onEditingComplete: (() {
                //     setState(() {});
                //   }),
                // ),

                // _imageUrlController.text.isEmpty
                //     ? Container()
                //     : Container(
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
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
