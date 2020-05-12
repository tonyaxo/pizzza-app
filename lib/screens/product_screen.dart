

import 'package:flutter/material.dart';
import 'package:foodcourt/models/product.dart';

class ProductScreen extends StatelessWidget {

  final double mainPadding = 15.0;
  
  final Product _product;

  ProductScreen(this._product);

  @override
  Widget build(BuildContext context) {

    final imageWidth = MediaQuery.of(context).size.width - mainPadding * 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down), 
          onPressed: () { Navigator.pop(context); }
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_basket), 
            onPressed: () { Navigator.pushNamed(context, '/cart'); }
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(mainPadding),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _getImage(_product, imageWidth, imageWidth)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _product.name, 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _product.attributes, 
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonBar(
                    children: <Widget>[
                      MaterialButton(onPressed: () {}, child: Text('Маленькая'), autofocus: true,),
                      MaterialButton(onPressed: () {}, child: Text('Средняя')),
                      MaterialButton(onPressed: () {}, child: Text('Большая')),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonBar(
                    children: <Widget>[
                      MaterialButton(onPressed: () {}, child: Text('Классическое')),
                      MaterialButton(onPressed: () {}, child: Text('Тонкое')),
                    ],
                  ),
                ],
              ),
            ]
          ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {},
              child: Text('Добавить в корзину за 500 р.', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              color: Theme.of(context).buttonColor,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              minWidth: double.maxFinite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImage(Product product, double width, double height) {
    return product.imageUrl == null 
      ? Image.asset('images/product-pizza-no-image.jpg', cacheHeight: height.toInt(),) 
      : FadeInImage.assetNetwork(
          placeholder: 'images/product-pizza-no-image.jpg', 
          image: product.imageUrl,
          width: width,
          height: height,
          // imageCacheWidth: width.toInt(),
          // imageCacheHeight: height.toInt(),
          fit: BoxFit.contain,
        );
  }
}