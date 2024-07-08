import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

mixin ToastMixin {
  void showToast(String string) {
    Fluttertoast.showToast(
      msg: string,
      toastLength: Toast.LENGTH_SHORT, // Toast.LENGTH_LONG for longer duration
      gravity: ToastGravity.BOTTOM, // ToastGravity.TOP for top
      timeInSecForIosWeb: 1, // the duration for which the toast should be visible
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}