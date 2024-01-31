import 'dart:convert';
import 'package:nb_asset_tracking_flutter/src/nb_encode.dart';

class IOSNotificationConfig with NBEncode {
  IOSNotificationConfig();

  // Configuration for asset enable notification
  var assetEnableNotificationConfig = AssetEnableNotificationConfig(identifier: "startTrackingIdentifier");

  // Configuration for asset disable notification
  var assetDisableNotificationConfig = AssetDisableNotificationConfig(identifier: "stopTrackingIdentifier");

  // Configuration for low battery notification
  var lowBatteryNotificationConfig = LowBatteryStatusNotificationConfig(identifier: "lowBatteryIdentifier");

  // A Boolean value to determine whether to show the asset enable notification.
  bool showAssetEnableNotification = true;

  // A Boolean value to determine whether to show the asset disable notification.
  bool showAssetDisableNotification = true;

  // A Boolean value to determine whether to show the low battery notification.
  bool showLowBatteryNotification = false;

  factory IOSNotificationConfig.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);

    var iosNotificationConfig = IOSNotificationConfig();
    iosNotificationConfig.assetEnableNotificationConfig =
        AssetEnableNotificationConfig.fromJson(json['assetEnableNotificationConfig']);
    iosNotificationConfig.assetDisableNotificationConfig =
        AssetDisableNotificationConfig.fromJson(json['assetDisableNotificationConfig']);
    iosNotificationConfig.lowBatteryNotificationConfig =
        LowBatteryStatusNotificationConfig.fromJson(json['lowBatteryNotificationConfig']);
    iosNotificationConfig.showAssetEnableNotification = json['showAssetEnableNotification'];
    iosNotificationConfig.showAssetDisableNotification = json['showAssetDisableNotification'];
    iosNotificationConfig.showLowBatteryNotification = json['showLowBatteryNotification'];
    return iosNotificationConfig;
  }

  Map<String, dynamic> toJson() {
    return {
      'assetEnableNotificationConfig': assetEnableNotificationConfig.toJson(),
      'assetDisableNotificationConfig': assetDisableNotificationConfig.toJson(),
      'lowBatteryNotificationConfig': lowBatteryNotificationConfig.toJson(),
      'showAssetEnableNotification': showAssetEnableNotification,
      'showAssetDisableNotification': showAssetDisableNotification,
      'showLowBatteryNotification': showLowBatteryNotification,
    };
  }
}

class _DefaultAssetNotificationConfig {
  // A unique identifier for the notification configuration.
  String identifier;

  // The title of the notification.
  String title;

  // The content of the notification.
  String content;

  // Initializes a new instance of the notification configuration.
  _DefaultAssetNotificationConfig({required this.identifier, required this.title, required this.content});
}

class AssetEnableNotificationConfig extends _DefaultAssetNotificationConfig {
  AssetEnableNotificationConfig({required String identifier})
      : super(
          identifier: identifier,
          title: "",
          content: "Asset tracking is now enabled and your device’s location will be tracked",
        );

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'title': title,
      'content': content,
    };
  }

  factory AssetEnableNotificationConfig.fromJson(Map<String, dynamic> json) {
    var assetEnableNotificationConfig = AssetEnableNotificationConfig(
      identifier: json['identifier'],
    );
    assetEnableNotificationConfig.title = json['title'];
    assetEnableNotificationConfig.content = json['content'];
    return assetEnableNotificationConfig;
  }
}

class AssetDisableNotificationConfig extends _DefaultAssetNotificationConfig {
  String assetIDTrackedContent =
      "Asset [assetId] is being tracked on another device. Tracking has been stopped on this device";

  AssetDisableNotificationConfig({required String identifier})
      : super(
          identifier: identifier,
          title: "",
          content: "Asset tracking is now disabled and your device's location will no longer be tracked",
        );

  factory AssetDisableNotificationConfig.fromJson(Map<String, dynamic> json) {
    var assetDisableNotificationConfig = AssetDisableNotificationConfig(
      identifier: json['identifier'],
    );
    assetDisableNotificationConfig.title = json['title'];
    assetDisableNotificationConfig.content = json['content'];
    assetDisableNotificationConfig.assetIDTrackedContent = json['assetIDTrackedContent'];
    return assetDisableNotificationConfig;
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'title': title,
      'content': content,
      'assetIDTrackedContent': assetIDTrackedContent,
    };
  }
}

class LowBatteryStatusNotificationConfig extends _DefaultAssetNotificationConfig {
  late double minBatteryLevel;

  LowBatteryStatusNotificationConfig({
    required String identifier,
    this.minBatteryLevel = 10,
  }) : super(
          identifier: identifier,
          title: "",
          content:
              "Your device’s battery level is lower than $minBatteryLevel. Please recharge to continue tracking assets",
        );

  factory LowBatteryStatusNotificationConfig.fromJson(Map<String, dynamic> json) {
    var lowBatteryStatusNotificationConfig =
        LowBatteryStatusNotificationConfig(identifier: json['identifier'], minBatteryLevel: double.parse(json['minBatteryLevel'].toString()));
    lowBatteryStatusNotificationConfig.title = json['title'];
    lowBatteryStatusNotificationConfig.content = json['content'];
    return lowBatteryStatusNotificationConfig;
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'title': title,
      'content': content,
      'minBatteryLevel': minBatteryLevel,
    };
  }
}
