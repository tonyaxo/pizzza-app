

import 'package:flutter/material.dart';
import 'package:foodcourt/router/router.dart';

import '../models/product.dart';

class ProductListItem extends StatelessWidget {

  static final height = 150.0;

  static final imageSize = 130.0;

  final Product _product;

  ProductListItem(this._product);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context, 
        Router.productPath,
        arguments: _product
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        key: Key(this._product.code),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                _getImage(),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 7.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _getName(), 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 7.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      _getDescription(), 
                      style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16.0, color: Colors.grey[900]),
                    ),
                  ),
                ],
              ),
            )
            
          ],
        ),
      ),
    );
  }

  String _getName() {
    return _product.name.length > 32 ? _product.name.substring(0, 32) : _product.name;
  }

  String _getDescription() {
    return _product.attributes.length > 100 ? _product.attributes.substring(0, 100) : _product.attributes;
  }
  

  Widget _getImage() {
    return _product.imageUrl == null 
      ? Image.asset('images/product-pizza-no-image.jpg', height: imageSize,) 
      : FadeInImage.assetNetwork(
          placeholder: 'images/product-pizza-no-image.jpg', 
          image: _product.imageUrl,
          placeholderCacheWidth: imageSize.toInt(),
          placeholderCacheHeight: imageSize.toInt(),
          imageCacheWidth: imageSize.toInt(),
          imageCacheHeight: imageSize.toInt(),
        );
  }
}