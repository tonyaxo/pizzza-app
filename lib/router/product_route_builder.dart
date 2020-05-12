

import 'package:flutter/widgets.dart';

class ProductRoute extends PageRouteBuilder {

  final Widget wiget;

  ProductRoute({this.wiget}): super(
    pageBuilder: (context, animation, secondaryAnimation) => wiget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}