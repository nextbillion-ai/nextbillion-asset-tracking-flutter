import 'dart:convert';

import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter/src/asset_detail_info.dart';
import 'package:nb_asset_tracking_flutter/src/low_battery_notification_config.dart';

class AssetResult<T> {
  bool success;
  T data;
  String? msg;

  AssetResult({required this.success, required this.data, this.msg});

  factory AssetResult.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    var data = json['data'];
    late T entity;
    if (T == AssetProfile) {
      entity = AssetProfile.fromJson(data) as T;
    } else if (T == DataTrackingConfig) {
      entity = DataTrackingConfig.fromJson(data) as T;
    } else if (T == DefaultConfig) {
      entity = DefaultConfig.fromJson(data) as T;
    } else if (T == LocationConfig) {
      entity = LocationConfig.fromJson(data) as T;
    } else if (T == LowBatteryNotificationConfig) {
      entity = LowBatteryNotificationConfig.fromJson(data) as T;
    } else if (T == AndroidNotificationConfig) {
      entity = AndroidNotificationConfig.fromJson(data) as T;
    } else if (T == IOSNotificationConfig) {
      entity = IOSNotificationConfig.fromJson(data) as T;
    } else if (T == AssetDetailInfo) {
      entity = AssetDetailInfo.fromJson(data) as T;
    } else if (T == TripSummary) {
      entity = TripSummary.fromJson(data) as T;
    } else if (T == TripInfo) {
      entity = TripInfo.fromJson(data) as T;
    } else {
      entity = data as T;
    }
    return AssetResult(
      success: json['success'] as bool,
      data: entity,
      msg: json['msg'] as String?,
    );
  }
}
