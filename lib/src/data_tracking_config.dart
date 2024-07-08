import 'dart:convert';

import 'constants.dart';
import 'nb_encode.dart';

class DataTrackingConfig with NBEncode {
  String baseUrl;
  int dataStorageSize;
  int dataUploadingBatchSize;
  int dataUploadingBatchWindow;
  bool shouldClearLocalDataWhenCollision;

  DataTrackingConfig({
    this.baseUrl = Constants.defaultBaseUrl, // Replace with actual default value
    this.dataStorageSize = Constants.defaultDataStorageSize, // Replace with actual default value
    this.dataUploadingBatchSize = Constants.defaultDataBatchSize, // Replace with actual default value
    this.dataUploadingBatchWindow = Constants.defaultBatchWindow, // Replace with actual default value
    this.shouldClearLocalDataWhenCollision = Constants.shouldClearLocalDataWhenCollision,
  });

  factory DataTrackingConfig.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return DataTrackingConfig(
      baseUrl: json['baseUrl'] as String,
      dataStorageSize: json['dataStorageSize'] as int,
      dataUploadingBatchSize: json['dataUploadingBatchSize'] as int,
      dataUploadingBatchWindow: json['dataUploadingBatchWindow'] as int,
      shouldClearLocalDataWhenCollision: json['shouldClearLocalDataWhenCollision'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'dataStorageSize': dataStorageSize,
      'dataUploadingBatchSize': dataUploadingBatchSize,
      'dataUploadingBatchWindow': dataUploadingBatchWindow,
      'shouldClearLocalDataWhenCollision': shouldClearLocalDataWhenCollision,
    };
  }
}
