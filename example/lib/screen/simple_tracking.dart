import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/util/consts.dart';
import 'package:nb_asset_tracking_flutter_example/util/permiss_checker.dart';
import 'package:nb_asset_tracking_flutter_example/util/toast_mixin.dart';
import 'package:uuid/uuid.dart';

class SimpleTrackingExample extends StatefulWidget {
  @override
  SimpleTrackingExampleState createState() => SimpleTrackingExampleState();
}

class SimpleTrackingExampleState extends State<SimpleTrackingExample>
    with ToastMixin
    implements OnTrackingDataCallBack {
  bool bindAsset = false;
  final assetTracking = AssetTracking();
  String locationInfo = "";
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: (bindAsset && !isTracking)
                      ? () async {
                          if (Platform.isAndroid) {
                            var granted = await checkAndRequestLocationPermission();
                            if (!granted) {
                              showToast("Please granted location access for this app");
                              return;
                            }
                          }
                          if (assetId.isEmpty) {
                            showToast("You mast bind a asset Id first");
                            return;
                          }
                          assetTracking.startTracking();
                        }
                      : null,
                  child: const Text("Start Tracking"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: isTracking
                        ? () {
                      assetTracking.stopTracking();
                    }
                        : null,
                    child: const Text("Stop Tracking"),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("Current Asset id: $assetId"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Text("Asset Tracking status: ${isTracking ? "on" : "off"} "),
            ),
            Text(locationInfo)
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
        showToast("Bind asset successfully with asset id ${assetResult.data}");
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
