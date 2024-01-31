import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/toast_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'consts.dart';

class CreateAssteScreen extends StatefulWidget {
  const CreateAssteScreen({super.key});

  @override
  State<CreateAssteScreen> createState() => _CreateAsstScreenState();
}

class _CreateAsstScreenState extends State<CreateAssteScreen> with ToastMixin {
  final _customIDTextController = TextEditingController();
  final _assetNameTextController = TextEditingController();
  final _assetDescriptionTextController = TextEditingController();
  final _assetAttribute1TextController = TextEditingController();
  final _assetAttribute2TextController = TextEditingController();
  final _assetBindIDTextController = TextEditingController();

  final _customDFocusNode = FocusNode();
  final _assetNameFocusNode = FocusNode();
  final _assetDescriptionFocusNode = FocusNode();
  final _assetAttribute1FocusNode = FocusNode();
  final _assetAttribute2FocusNode = FocusNode();
  final _assetBindIDFocusNode = FocusNode();

  String lastUsedAssetId = "";

  final assetTracking = AssetTracking();

  EnvConfig selectedEnvConfig = EnvConfig.prod;

  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    prefs = await SharedPreferences.getInstance();
    String createId = prefs.getString(keyOfBoundId) ?? "";
    _customIDTextController.text = createId;

    if (createId.isEmpty == true) {
      _customIDTextController.text = generateUUID();
    }
    _assetNameTextController.text = "My Car";
    _assetDescriptionTextController.text = "Nancy's BMW";
    _assetAttribute1TextController.text = "A test attribute key";
    _assetAttribute1TextController.text = "A test attribute value";
    _assetBindIDTextController.text = createId;
    lastUsedAssetId = createId;

    var envConfig = prefs.getString(keyOfEnvConfig);
    if (envConfig?.isNotEmpty == true) {
      setState(() {
        selectedEnvConfig = EnvConfig.fromString(envConfig!);
      });
    }
  }

  Future<void> createAsset() async {
    String customId = _customIDTextController.text;
    String assetName = _assetNameTextController.text;
    String description = _assetDescriptionTextController.text;
    String attribute1 = _assetAttribute1TextController.text;
    String attribute2 = _assetAttribute2TextController.text;

    AssetProfile profile = AssetProfile(
        customId: customId, name: assetName, description: description, attributes: {attribute1: attribute2});
    AssetResult result = await assetTracking.createAsset(profile: profile);
    if (result.success) {
      showToast("Asset ${result.data} create success");
      _assetBindIDTextController.text = result.data;
    } else {
      showToast("Create asset failed: ${result.msg ?? ""}");
    }
  }

  Future<void> bindAsset() async {
    String assetId = _assetBindIDTextController.text;
    AssetResult result = await assetTracking.bindAsset(customId: assetId);

    if (result.success) {
      showToast("Asset ${result.data} bind success");
      saveData(result.data);
      Navigator.of(context).pop();
    } else {
      if (result.data == "2001") {
        _showDialog(() async {
          var assetResult = await assetTracking.forceBindAsset(customId: assetId);
          if (assetResult.success) {
            saveData(assetId);
            showToast("Force bind new asset successfully with assetId: $assetId");
            Navigator.pop(context);
          } else {
            showToast("Bind Failed: ${result.msg ?? ""}");
          }
        }, title: "Bind Failed", msg: "${result.msg}, do you want to clear local data and force bind to new asset id?");
      } else {
        showToast("Bind Failed: ${result.msg ?? ""}");
      }
    }
  }

  void saveData(String boundId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyOfBoundId, boundId);
    setState(() {
      lastUsedAssetId = boundId;
    });
  }

  String generateUUID() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  Future<void> _showDialog(VoidCallback okPressedCallback, {required String title, required String msg}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                okPressedCallback();
                Navigator.of(context).pop();
              },
              child: Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Asset'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CupertinoSegmentedControl<EnvConfig>(
                padding: EdgeInsets.zero,
                children: const {
                  EnvConfig.prod: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "prod",
                        style: TextStyle(fontSize: 14),
                      )),
                  EnvConfig.staging: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("staging", style: TextStyle(fontSize: 14)),
                  ),
                },
                groupValue: selectedEnvConfig,
                onValueChanged: (EnvConfig value) async {
                  setState(() {
                    prefs.setString(keyOfEnvConfig, value.name.split(".").last);
                    selectedEnvConfig = value;
                    assetTracking.setDataTrackingConfig(
                        config: DataTrackingConfig(
                            baseUrl: selectedEnvConfig == EnvConfig.prod ? baseUrlProd : baseUrlStaging));
                  });
                },
                unselectedColor: Colors.white,
              ),
            ),
            TextField(
              controller: _customIDTextController,
              focusNode: _customDFocusNode,
              decoration: const InputDecoration(labelText: 'Custom ID'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                _fieldFocusChange(context, _customDFocusNode, _assetNameFocusNode);
              },
            ),
            TextField(
              controller: _assetNameTextController,
              focusNode: _assetNameFocusNode,
              decoration: const InputDecoration(labelText: 'Asset Name'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                _fieldFocusChange(context, _assetNameFocusNode, _assetDescriptionFocusNode);
              },
            ),
            TextField(
              controller: _assetDescriptionTextController,
              focusNode: _assetDescriptionFocusNode,
              decoration: const InputDecoration(labelText: 'Asset Description'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                _fieldFocusChange(context, _assetDescriptionFocusNode, _assetAttribute1FocusNode);
              },
            ),
            TextField(
              controller: _assetAttribute1TextController,
              focusNode: _assetAttribute1FocusNode,
              decoration: const InputDecoration(labelText: 'Asset Attribute 1'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                _fieldFocusChange(context, _assetAttribute1FocusNode, _assetAttribute2FocusNode);
              },
            ),
            TextField(
              controller: _assetAttribute2TextController,
              focusNode: _assetAttribute2FocusNode,
              decoration: const InputDecoration(labelText: 'Asset Attribute 2'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                _fieldFocusChange(context, _assetAttribute2FocusNode, _assetBindIDFocusNode);
              },
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  createAsset();
                },
                child: const Text('Create new Asset'),
              ),
            ),
            TextField(
              controller: _assetBindIDTextController,
              focusNode: _assetBindIDFocusNode,
              decoration: const InputDecoration(labelText: 'Asset Bind ID'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {},
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  bindAsset();
                },
                child: const Text('Bind Asset'),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text("Your last used asset id"),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(lastUsedAssetId),
            ),
          ],
        ),
      ),
    );
  }

  void _fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _customIDTextController.dispose();
    _assetNameTextController.dispose();
    _assetDescriptionTextController.dispose();
    _assetAttribute1TextController.dispose();
    _assetAttribute2TextController.dispose();
    _assetBindIDTextController.dispose();

    _customDFocusNode.dispose();
    _assetNameFocusNode.dispose();
    _assetDescriptionFocusNode.dispose();
    _assetAttribute1FocusNode.dispose();
    _assetAttribute2FocusNode.dispose();
    _assetBindIDFocusNode.dispose();

    super.dispose();
  }
}
