
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mixins/format_price.dart';
import '../store/cart_store.dart';
import '../models/cart_info.dart';

class PromotionInfo extends StatelessWidget with FormatPrice {

  final Promotion promo;

  PromotionInfo(this.promo);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartStore>(context, listen: false);
    
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0.0),
        leading: Padding(padding: EdgeInsets.only(left: 10.0),
          child: Icon(CupertinoIcons.check_mark_circled, color: Colors.green),
        ),
        title: Text(
          'Код ${promo.name}', maxLines: 3,
        ),
        subtitle: Text(
          'Скидка ${asCurrency(promo.currentAmount, promo.currency, locale: cart.info.locale)}',
          maxLines: 3,
        ),
        trailing: _buildTrailing(cart),
      ),
    );
  }

  Widget _buildTrailing(CartStore cart) {
    // if (!promo.isCoupon) {
    //   return null;
    // }

    return MaterialButton(
      onPressed: () async {
        await cart.deleteCoupon();
      },
      child: Text('Отменить'),
    );
  }
}