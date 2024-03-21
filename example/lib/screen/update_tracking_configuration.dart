import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/util/consts.dart';
import 'package:nb_asset_tracking_flutter_example/util/toast_mixin.dart';
import 'package:uuid/uuid.dart';

class UpdateConfigurationExample extends StatefulWidget {
  @override
  UpdateConfigurationExampleState createState() => UpdateConfigurationExampleState();
}

class UpdateConfigurationExampleState extends State<UpdateConfigurationExample>
    with ToastMixin
    implements OnTrackingDataCallBack {
  bool bindAsset = false;
  final assetTracking = AssetTracking();
  String locationInfo = "";
  String configInfo = "";
  String assetId = "";
  bool isTracking = false;

  @override
  void initState() {
    super.initState();
    initAssetTracking();
    createAndBindAssetId();
  }

  void initAssetTracking() {
    assetTracking.initialize(apiKey: accessKey);
    assetTracking.setFakeGpsConfig(allow: true);
    assetTracking.addDataListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: assetId.isNotEmpty
                  ? () async {
                      var locationConfig = LocationConfig(trackingMode: TrackingMode.custom, smallestDisplacement: 40);
                      await assetTracking.updateLocationConfig(config: locationConfig);
                      var locationConfigResult = await assetTracking.getLocationConfig();
                      setState(() {
                        configInfo = "locationConfigInfo: ${jsonEncode(locationConfigResult.data)}";
                      });
                    }
                  : null,
              child: const Text("Update Location Config"),
            ),
            ElevatedButton(
              onPressed: assetId.isNotEmpty
                  ? () async {
                      var androidNotificationConfig =
                          AndroidNotificationConfig(channelId: "testChannelId", channelName: "newChannelName");
                      var iOSNotificationConfig = IOSNotificationConfig();
                      iOSNotificationConfig.showAssetEnableNotification = false;
                      iOSNotificationConfig.showAssetDisableNotification = true;
                      var assetEnableConfig = AssetEnableNotificationConfig(identifier: "iosIdentifier");
                      assetEnableConfig.title = "New asset enable notification title";
                      iOSNotificationConfig.assetEnableNotificationConfig = assetEnableConfig;

                      if (Platform.isAndroid) {
                        assetTracking.setAndroidNotificationConfig(config: androidNotificationConfig);
                        var androidConfig = await assetTracking.getAndroidNotificationConfig();
                        setState(() {
                          configInfo = "notificationConfig: ${jsonEncode(androidConfig.data)}";
                        });
                      } else {
                        assetTracking.setIOSNotificationConfig(config: iOSNotificationConfig);
                        var iosConfig = await assetTracking.getIOSNotificationConfig();
                        setState(() {
                          configInfo = "notificationConfig: ${jsonEncode(iosConfig.data)}";
                        });
                      }
                    }
                  : null,
              child: const Text("Update Notification Config"),
            ),
            ElevatedButton(
              onPressed: assetId.isNotEmpty
                  ? () async {
                      var dataTrackingConfig = DataTrackingConfig(
                          dataUploadingBatchSize: 15, dataUploadingBatchWindow: 30, dataStorageSize: 5000);
                      await assetTracking.setDataTrackingConfig(config: dataTrackingConfig);
                      var dataTrackingConfigInfo = await assetTracking.getDataTrackingConfig();
                      setState(() {
                        configInfo = "dataTrackingConfigInfo: ${jsonEncode(dataTrackingConfigInfo.data)}";
                      });
                    }
                  : null,
              child: const Text("Update DataTracking Config"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(configInfo),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Text(locationInfo),
            ),
          ],
        ),
      ),
    );
  }

  void createAndBindAssetId() async {
    AssetProfile profile = AssetProfile(
        customId: const Uuid().v4().toString(), name: "test asset", description: "asset descriptions", attributes: {});
    AssetResult result = await assetTracking.createAsset(profile: profile);
    if (result.success) {
      String assetID = result.data;
      var assetResult = await assetTracking.bindAsset(customId: assetID);
      if (assetResult.success) {
        showToast("Asset ${result.data} bind success");
        setState(() {
          assetId = assetResult.data;
          bindAsset = true;
        });
      } else {
        showToast(assetResult.msg.toString());
      }
    } else {
      showToast(result.msg.toString());
    }
  }

  @override
  void onLocationFailure(String message) {}

  @override
  void onLocationSuccess(NBLocation location) {
    setState(() {
      locationInfo = "------- Location Info ------- \n"
          "Provider: ${location.provider} \n"
          "Latitude: ${location.latitude}\n"
          "Longitude: ${location.longitude}\n"
          "Altitude: ${location.altitude}\n"
          "Accuracy: ${location.accuracy}\n"
          "Speed: ${location.speed}\n"
          "Bearing: ${location.heading}\n"
          "Time: ${location.timestamp}\n";
    });
  }

  @override
  void onTrackingStart(String message) {
    setState(() {
      isTracking = true;
    });
  }

  @override
  void onTrackingStop(String message) {
    setState(() {
      isTracking = false;
      locationInfo = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    assetTracking.removeDataListener(this);
    assetTracking.stopTracking();
  }
}
