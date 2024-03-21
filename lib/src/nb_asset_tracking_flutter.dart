import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter/src/asset_detail_info.dart';
import 'native_result_callback.dart';
import 'nb_asset_tracking_flutter_platform_interface.dart';

class AssetTracking {
  final List<OnTrackingDataCallBack> _listeners = [];

  late NativeResultCallback _nativeCallbacks;

  late NbAssetTrackingFlutterPlatform _platform;

  static final AssetTracking _instance = AssetTracking._internal();

  AssetTracking._internal() {
    _platform = NbAssetTrackingFlutterPlatform.instance;
    initNativeCallbacks();
    _platform.setupResultCallBack(_nativeCallbacks);
  }

  factory AssetTracking() {
    return _instance;
  }

  Future<void> initialize({required String apiKey}) async {
    await NbAssetTrackingFlutterPlatform.instance.initialize(key: apiKey);
  }

  void addDataListener(OnTrackingDataCallBack callback) {
    _listeners.add(callback);
  }

  void removeDataListener(OnTrackingDataCallBack callback) {
    _listeners.remove(callback);
  }

  void removeAllDataListener() {
    _listeners.clear();
  }

  Future<void> startTracking() async {
    await NbAssetTrackingFlutterPlatform.instance.startTracking();
  }

  Future<void> stopTracking() async {
    await _platform.stopTracking();
  }

  Future<AssetResult<String>> getAssetId() async {
    String jsonString = await _platform.getAssetId();
    return AssetResult.fromJson(jsonString);
  }

  Future<AssetResult<String>> updateAsset({required AssetProfile assetProfile}) async {
    String jsonString = await _platform.updateAsset(assetProfile: assetProfile);
    return AssetResult.fromJson(jsonString);
  }

  Future<AssetResult<AssetDetailInfo>> getAssetDetail() async {
    String jsonString = await _platform.getAssetDetail();
    return AssetResult.fromJson(jsonString);
  }

  Future<void> setDefaultConfig({required DefaultConfig config}) async {
    await NbAssetTrackingFlutterPlatform.instance.setDefaultConfig(config: config);
  }

  Future<AssetResult<DefaultConfig>> getDefaultConfig() async {
    String jsonString = await _platform.getDefaultConfig();
    return AssetResult.fromJson(jsonString);
  }

  Future<void> setAndroidNotificationConfig({required AndroidNotificationConfig config}) async {
    await _platform.setAndroidNotificationConfig(config: config);
  }

  Future<AssetResult<AndroidNotificationConfig>> getAndroidNotificationConfig() async {
    String json = await _platform.getAndroidNotificationConfig();
    return AssetResult.fromJson(json);
  }

  Future<void> setIOSNotificationConfig({required IOSNotificationConfig config}) async {
    await _platform.setIOSNotificationConfig(config: config);
  }

  Future<AssetResult<IOSNotificationConfig>> getIOSNotificationConfig() async {
    String json = await _platform.getIOSNotificationConfig();
    return AssetResult.fromJson(json);
  }

  Future<void> updateLocationConfig({required LocationConfig config}) async {
    await _platform.updateLocationConfig(config: config);
  }

  Future<void> setLocationConfig({required LocationConfig config}) async {
    await _platform.setLocationConfig(config: config);
  }

  Future<AssetResult<LocationConfig>> getLocationConfig() async {
    String json = await _platform.getLocationConfig();
    return AssetResult.fromJson(json);
  }

  Future<void> setDataTrackingConfig({required DataTrackingConfig config}) async {
    await _platform.setDataTrackingConfig(config: config);
  }

  Future<AssetResult<bool>> getFakeGpsConfig() async {
    String jsonString = await _platform.getFakeGpsConfig();
    return AssetResult.fromJson(jsonString);
  }

  Future<void> setFakeGpsConfig({required bool allow}) async {
    await _platform.setFakeGpsConfig(allow: allow);
  }

  Future<AssetResult<DataTrackingConfig>> getDataTrackingConfig() async {
    String jsonString = await _platform.getDataTrackingConfig();
    return AssetResult.fromJson(jsonString);
  }

  Future<AssetResult<bool>> isTracking() async {
    String jsonString = await _platform.isTracking();
    return AssetResult.fromJson(jsonString);
  }

  Future<AssetResult<String>> createAsset({required AssetProfile profile}) async {
    String jsonString = await _platform.createAsset(profile: profile);
    return AssetResult.fromJson(jsonString);
  }

  Future<AssetResult<String>> bindAsset({required String customId}) async {
    String jsonString = await _platform.bindAsset(customId: customId);
    return AssetResult.fromJson(jsonString);
  }

  Future<AssetResult<String>> forceBindAsset({required String customId}) async {
    String jsonString = await _platform.forceBindAsset(customId: customId);
    return AssetResult.fromJson(jsonString);
  }

  void initNativeCallbacks() {
    _nativeCallbacks = NativeResultCallback(
      onLocationSuccess: (NBLocation location) {
        for (var listener in _listeners) {
          listener.onLocationSuccess.call(location);
        }
      },
      onLocationFailure: (String message) {
        for (var listener in _listeners) {
          listener.onLocationFailure.call(message);
        }
      },
      onTrackingStart: (String assetId) {
        for (var listener in _listeners) {
          listener.onTrackingStart.call(assetId);
        }
      },
      onTrackingStop: (String assetId) {
        for (var listener in _listeners) {
          listener.onTrackingStop.call(assetId);
        }
      },
    );
  }
}
