

import 'dart:convert';
import 'dart:io';

class DataHelper {

  Future<String> asString(String dataName) async {

    // @see https://github.com/flutter/flutter/issues/20907
    var dir = Directory.current.path;
    if (dir.endsWith('/test')) {
      dir = dir.replaceAll('/test', '');
    }
    return await File('$dir/test/support/data/$dataName.json').readAsString();
  }

  Future<dynamic> asJson(String dataName) async {
    var data = await asString(dataName);
    return json.decode(data);
  }
}