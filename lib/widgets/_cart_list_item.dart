

import 'package:flutter/material.dart';
import '../mixins/format_price.dart';
import '../store/cart_store.dart';
import '../widgets/quantity_switch.dart';

import 'package:provider/provider.dart';

import '../models/cart_info.dart';

class CartListItem extends StatelessWidget with FormatPrice {

  static final height = 150.0;

  static final imageSize = 100.0;

  final CartItem _item;

  CartListItem(this._item);

  @override
  Widget build(BuildContext context) {

    var cart = Provider.of<CartStore>(context);

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10.0),
        key: Key(this._item.id.toString()),
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
                    child: _buildDescription(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 7.0),
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        QuntitySwitch(
                          index: _item.id,
                          value: _item.quantity, 
                          minValue: 0,
                          onChanged: (increment) async {
                            var newQuantity = increment ? _item.quantity + 1 : _item.quantity - 1;
                            if (newQuantity < 1) {
                              await cart.deleteItem(_item.id);
                            } else {
                              await cart.changeQuantity(_item.id, newQuantity);
                            }
                          }
                        ),
                        Text(
                          asCurrency(_item.total, _item.product.minPrice.currency), 
                          style: TextStyle(fontSize: 18.0, color: Colors.black)
                        ),
                      ],
                    ) 
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
    return _item.product.name.length > 32 ? _item.product.name.substring(0, 32) : _item.product.name;
  }

  /// Builds description widget.
  Widget _buildDescription() {
    if (_item.product.isSimple) {
      return null;
    }

    var variant = _item.product.variants.entries.first.value;
    String description = variant.nameAxis.join(', ');
    
    return Text(
      description, 
      style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16.0, color: Colors.grey[900]),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _getImage() {
    return _item.product.imageUrl == null 
      ? Image.asset('images/product-pizza-no-image.jpg', height: imageSize,) 
      : FadeInImage.assetNetwork(
          placeholder: 'images/product-pizza-no-image.jpg', 
          image: _item.product.imageUrl,
          placeholderCacheWidth: imageSize.toInt(),
          placeholderCacheHeight: imageSize.toInt(),
          imageCacheWidth: imageSize.toInt(),
          imageCacheHeight: imageSize.toInt(),
        );
  }
}