import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/util/toast_mixin.dart';
import 'package:uuid/uuid.dart';

class AssetProfileScreen extends StatefulWidget {
  const AssetProfileScreen({super.key});

  @override
  AssetProfileScreenState createState() => AssetProfileScreenState();
}

class AssetProfileScreenState extends State<AssetProfileScreen> with ToastMixin {
  final assetTracking = AssetTracking();
  String assetId = "";
  String assetDetailInfo = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: assetId.isEmpty
                  ? () async {
                      AssetProfile profile = AssetProfile(
                          customId: const Uuid().v4().toString(),
                          name: "test asset",
                          description: "asset descriptions",
                          attributes: {});
                      AssetResult result = await assetTracking.createAsset(profile: profile);
                      if (result.success) {
                        showToast("Create asset successfully with asset id ${result.data}");
                        setState(() {
                          assetId = result.data;
                        });
                      } else {
                        showToast(result.msg.toString());
                      }
                    }
                  : null,
              child: const Text("Create New Asset"),
            ),
            ElevatedButton(
              onPressed: assetId.isNotEmpty
                  ? () async {
                      var assetResult = await assetTracking.bindAsset(customId: assetId);
                      if (assetResult.success) {
                        showToast("Bind asset successfully with asset id ${assetResult.data}");
                      } else {
                        showToast(assetResult.msg.toString());
                      }
                    }
                  : null,
              child: const Text("Bind Asset"),
            ),
            ElevatedButton(
              onPressed: assetId.isNotEmpty
                  ? () async {
                      var assetProfile = AssetProfile(
                          customId: assetId,
                          name: "new name",
                          description: "new description",
                          attributes: {"attribute1": "tester1"});
                      var assetDetail = await assetTracking.updateAsset(assetProfile: assetProfile);
                      if (assetDetail.success) {
                        showToast("Update Asset Info successfully");
                      } else {
                        showToast(assetDetail.msg.toString());
                      }
                    }
                  : null,
              child: const Text("Update Asset Info"),
            ),
            ElevatedButton(
              onPressed: assetId.isNotEmpty
                  ? () async {
                      var assetDetail = await assetTracking.getAssetDetail();
                      if (assetDetail.success) {
                        setState(() {
                          assetDetailInfo = jsonEncode(assetDetail.data);
                        });
                      } else {
                        showToast(assetDetail.msg.toString());
                      }
                    }
                  : null,
              child: const Text("Get Asset Detail"),
            ),
            Text(assetDetailInfo)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
