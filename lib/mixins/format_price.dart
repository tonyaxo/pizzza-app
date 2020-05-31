

import 'package:intl/intl.dart';

mixin FormatPrice {

  final _localeMap = <String, String>{
    'RUB': 'ru_RU',
    'USD': 'en_US',
  };

  /// Formats current price and return it.
  String asCurrency(int value, String currency, {String locale}) {
    if (locale == null) {
      locale = _localeMap.containsKey(currency) ? _localeMap[currency] : null;
    }
    var price = NumberFormat.simpleCurrency(name: currency, locale: locale.toString(), decimalDigits: 0);
    return price.format(value / 100);
  }
}