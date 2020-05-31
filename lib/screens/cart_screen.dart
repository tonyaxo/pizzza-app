

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodcourt/widgets/coupon_input_form.dart';
import 'package:foodcourt/widgets/promotion_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../models/cart_info.dart';
import '../widgets/bottom_bar.dart';
import '../store/cart_store.dart';
import '../widgets/_cart_list_item.dart';
import '../mixins/format_price.dart';

class CartScreen extends StatelessWidget with FormatPrice {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Корзина')
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: BottomBar(height: 80.0,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCheckoutButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<CartStore>(
      builder: (_, cart, __) {
        return cart.info.isEmpty ? _buildEmpty(context) : _buildNotEmpty(context, cart);
      }
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Text('Пусто!'),
      ),
    );
  }

  Widget _buildNotEmpty(BuildContext context, CartStore cart) {
    return Observer(
      builder: (context) {
        return  ListView(
          children: cart.info.items.entries.map<Widget>((entry) => CartListItem(entry.value)).toList() 
          + [
            _buildPromotionInfo(context, cart),
            Divider(),
            _buildTotal(context, cart)
          ]
        );
      }
    );
  }

  Widget _buildPromotionInfo(BuildContext context, CartStore cart) {
    var children = List<Widget>();

    if (cart.info.discounts.isNotEmpty) {
      children.addAll(
        cart.info.discounts.entries.map<Widget>(
          (entity) => PromotionInfo(entity.value)
        ).toList()
      );
    }
    if (!cart.info.hasCoupon) {
      children.add(_buildAddCouponButton(context, cart));
    }

    return Column(
      children: children,
    );
  }

  Widget _buildAddCouponButton(BuildContext context, CartStore cart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OutlineButton(
          onPressed: () { showCouponModal(context, cart); }, 
          child: Text('Добавить купон'),
          borderSide: BorderSide(
            color: Colors.orange[100],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ]
    );
  }

  void showCouponModal(BuildContext context, CartStore cart) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.keyboard_arrow_down), onPressed: () { Navigator.pop(context); })
                ],
              ),
              CouponInputForm(onAppliedSuccess: () {
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
    );
  }

  /// Builds total table view.
  Widget _buildTotal(BuildContext context, CartStore cart) {
    Total totals = cart.info.totals;
    String currency = cart.info.currency;
    String locale = cart.info.locale;

    TextStyle headerStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
    );
    TextStyle dataStyle = TextStyle(fontSize: 18.0);

    return Padding(
      padding: EdgeInsets.only(
        top: 10.0, right: 20.0, left: 20.0, bottom: 30.0
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            TableCell(
              child: Text('Всего', style: headerStyle),
            ),
            TableCell(
              child: Align(alignment: Alignment.centerRight,
                child: Text(asCurrency(totals.total, currency, locale: locale), style: dataStyle,),
              ),
            ),
          ]),
          TableRow(children: [
            TableCell(
              child: Text('Доставка', style: headerStyle),
            ),
            TableCell(
              child: Align(alignment: Alignment.centerRight,
                child: Text(asCurrency(totals.shipping, currency, locale: locale), style: dataStyle,),
              ),
            ),
          ]),
          TableRow(children: [
            TableCell(
              child: Text('Скидка', style: headerStyle),
            ),
            TableCell(
              child: Align(alignment: Alignment.centerRight,
                child: Text(asCurrency(totals.promotion, currency, locale: locale), style: dataStyle,),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  /// Returns checkout button.
  Widget _buildCheckoutButton(BuildContext context) {
    var cart = Provider.of<CartStore>(context);

    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          onPressed: () async {
            // CartStore cart = Provider.of<CartStore>(context, listen: false);
            // await cart.add(
            //   widget._product.code, 
            //   variantCode: widget._product.isConfigurable ? _currentVariant.code : null
            // );
          },
          child: Observer(
            builder: (_) {
              return Text(
                'Оформить заказ на ${asCurrency(cart.info.totals.total, cart.info.currency)}', 
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
              );
            }
          ),
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
}