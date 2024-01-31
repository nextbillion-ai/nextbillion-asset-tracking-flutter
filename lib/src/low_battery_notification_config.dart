
import 'dart:convert';

import 'nb_encode.dart';

class LowBatteryNotificationConfig with NBEncode {
  final double threshold;
  final String channelId;
  final String channelName;
  final String title;
  final String content;
  final int smallIcon;

  static const LowBatteryNotificationConfig defaultConfig = LowBatteryNotificationConfig();

  const LowBatteryNotificationConfig({
    this.threshold = 10.0,
    this.channelId = 'LowBatteryChannelId', // Replace with actual default value
    this.channelName = 'LowBatteryChannelName', // Replace with actual default value
    this.title = 'Default Notification Title', // Replace with actual default value
    this.content = 'Your device’s battery level is low. Please recharge to continue tracking assets',
    this.smallIcon = 0, // Replace with an appropriate integer or other identifier
  });

  factory LowBatteryNotificationConfig.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return LowBatteryNotificationConfig(
      threshold: (json['threshold'] as num).toDouble(),
      channelId: json['channelId'] as String,
      channelName: json['channelName'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      smallIcon: json['smallIcon'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'threshold': threshold,
      'channelId': channelId,
      'channelName': channelName,
      'title': title,
      'content': content,
      'smallIcon': smallIcon,
    };
  }

}