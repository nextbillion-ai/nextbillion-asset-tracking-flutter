import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../util/consts.dart';

// 存储 List<String>
Future<void> storeTripHistory(String tripId) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> list = await getHistoryList();
  String jsonString = jsonEncode(list..add(tripId));
  await prefs.setString(keyOfTripHistory, jsonString);
}

// 读取 List<String>
Future<List<String>> getHistoryList() async {
  final prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(keyOfTripHistory);
  if (jsonString != null) {
    List<dynamic> jsonList = jsonDecode(jsonString);
    return List<String>.from(jsonList);
  } else {
    return [];
  }
}
