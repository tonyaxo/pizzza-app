

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/cart_store.dart';

/// Validetes and applies coupone code to cart.
class CouponInputForm extends StatefulWidget {

  /// Callback after apply coupon.
  final void Function() onAppliedSuccess;

  CouponInputForm({this.onAppliedSuccess});

  @override
  _CouponInputFormState createState() => _CouponInputFormState();
}

/// State
class _CouponInputFormState extends State<CouponInputForm> {
  final controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /// Is entered coupon valid or not.
  bool couponValid = true;

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartStore>(context, listen: false);

    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: 
            TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 14),
                hintText: 'Ведите промокод',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              ),
              validator: (couponCode) {
                if (couponCode.isEmpty || !couponValid) {
                  return 'Код не может быть применен';
                }

                return null;
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () async {
                var couponCode = controller.text;
                if (couponCode.isNotEmpty) {
                  bool result = await cart.applyCoupon(couponCode);
                  setState(() {
                    couponValid = result;
                  });
                  if (couponValid && widget.onAppliedSuccess != null) {
                    widget.onAppliedSuccess();
                  }
                }
                _formKey.currentState.validate();
              }, 
              child: Text('применить')
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}