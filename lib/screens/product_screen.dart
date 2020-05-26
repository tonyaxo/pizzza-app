

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/product.dart';

/// Screen shows product description and let choose variant to buy.
class ProductScreen extends StatefulWidget {

  /// Product itself 
  final Product _product;

  ProductScreen(this._product);

  @override
  State<StatefulWidget> createState() => _ProductScreen();

  /// Widget to show image.
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

/// Screen state.
class _ProductScreen extends State<ProductScreen> with TickerProviderStateMixin {

  final double mainPadding = 15.0;

  /// Selected options [Map<optionCode, optionValueCode>]
  Map<String, String> _currentOptions = Map<String, String>();

  /// Selected varaint
  ProductVariant get _currentVariant {
    var options = _currentOptions.entries.map((e) => e.value).toList();
    var key = VariantKey(options);
    return widget._product.variants.containsKey(key) ? widget._product.variants[key] : null;
  }

  @override
  void initState() { 
    super.initState();
    _initBaseVariant();
  }

  /// Init base product varinat options.
  void _initBaseVariant() {
    widget._product.options.forEach((optionCode, option) {
      _currentOptions[optionCode] = option.values.entries.first.key;
    });
  }
  
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
                  widget._getImage(widget._product, imageWidth, imageWidth)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget._product.name, 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget._product.attributes, 
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ] + _buildOptions()
          ),
      ),
      bottomNavigationBar: _buildAddToCartButton(),      
    );
  }

  /// Returns segment control list of product options.
  List<Widget> _buildOptions() {
    List<Widget> result = List<Widget>();

    widget._product.options.forEach((optionCode, option) {
      result.add(_buildOption(optionCode, option.values));
    });
    
    return result;
  }

  /// Return segment control widget for concrete option.
  Widget _buildOption(String optionCode, Map<String, String> values) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 0.0,
            ),
            child: CupertinoSlidingSegmentedControl(
              padding: EdgeInsets.all(3.0),
              groupValue: _currentOptions[optionCode],
              children: values.map<dynamic, Widget>((key, value) => MapEntry(key, Text(value))),
              onValueChanged: (value) {
                setState(() {
                  _currentOptions[optionCode] = value;
                });
              }
            ),
          ),
        ),
      ],
    );
  }

  /// Returns big bottom "Add to Cart" botton widget.
  Widget _buildAddToCartButton() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          onPressed: () {},
          child: Text('Добавить в корзину за ${_getPrice()}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          color: Theme.of(context).buttonColor,
          textColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          minWidth: double.maxFinite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ],
    );
  }

  /// Formats current price and return it.
  String _getPrice() {
    Locale locale = Localizations.localeOf(context);
    var price = NumberFormat.simpleCurrency(name: _currentVariant.price.currency, locale: locale.toString());
    return price.format(_currentVariant.price.value / 100);
  }

  @override
  void dispose() {
    super.dispose();
  }
}