import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void QuntitySwitchChangeCallback(bool increment);

// TODO refactor
class QuntitySwitch extends StatelessWidget {

  final QuntitySwitchChangeCallback onChanged;

  QuntitySwitch({
    Key key,
    @required this.value,
    @required this.minValue,
    @required this.onChanged,
    @required this.index,
    this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
  }): super(key: key);

  ///min value user can pick
  final int minValue;

  final int index;

  ///Currently selected integer value
  final int value;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// indicates the color of fab used for increment and decrement
  final Color color;

  /// text syle
  final TextStyle textStyle;

  final double buttonSize;

  void _incrementCounter() {
    onChanged(true);
  }

  void _decrementCounter() {
    onChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    var color = this.color ?? themeData.accentColor;
    var textStyle = this.textStyle ?? new TextStyle(
      fontSize: 20.0,
    );

    return new Container(
      padding: new EdgeInsets.all(4.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: 'dec$index',
              onPressed: _decrementCounter,
              elevation: 2,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
              backgroundColor: color,
            ),
          ),
          new Container(
            padding: EdgeInsets.all(4.0),
            child: new Text(
                value.toString(),
                style: textStyle
            ),
          ),
          new SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              heroTag: 'inc$index',
              onPressed: _incrementCounter,
              elevation: 2,
              tooltip: 'Increment',
              child: Icon(Icons.add),
              backgroundColor: color,
            ),
          ),
        ],
      ),
    );
  }
}