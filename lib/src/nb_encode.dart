import 'dart:convert';

mixin NBEncode {
  String encode() {
    return jsonEncode(this);
  }
}