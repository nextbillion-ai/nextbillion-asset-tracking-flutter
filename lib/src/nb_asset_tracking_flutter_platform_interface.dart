import 'package:nb_asset_tracking_flutter/src/data_tracking_config.dart';
import 'package:nb_asset_tracking_flutter/src/default_config.dart';
import 'package:nb_asset_tracking_flutter/src/ios_notification_config.dart';
import 'package:nb_asset_tracking_flutter/src/android_notification_config.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_profile.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_update_profile.dart';

import 'asset_profile.dart';
import 'location_config.dart';
import 'native_result_callback.dart';
import 'nb_asset_tracking_flutter_method_channel.dart';

abstract class NbAssetTrackingFlutterPlatform extends PlatformInterface {
  /// Constructs a NbAssetTrackingFlutterPlatform.
   NbAssetTrackingFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static NbAssetTrackingFlutterPlatform _instance = MethodChannelNbAssetTrackingFlutter();

  /// The default instance of [NbAssetTrackingFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelNbAssetTrackingFlutter].
  static NbAssetTrackingFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NbAssetTrackingFlutterPlatform] when
  /// they register themselves.
  static set instance(NbAssetTrackingFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }


   Future<String> initialize({required String key}) {
     throw UnimplementedError('initialize() has not been implemented.');
   }

   Future<String> setKeyOfHeaderField({required String key}) {
     throw UnimplementedError('setKeyOfHeaderField() has not been implemented.');
   }

   void setupResultCallBack(NativeResultCallback callback) {
     throw UnimplementedError('setupResultCallBack() has not been implemented.');
   }

   Future<String> getAssetId() {
     throw UnimplementedError('getAssetId() has not been implemented.');
   }

   Future<String> updateAsset({required AssetProfile assetProfile}) {
     throw UnimplementedError('updateAsset() has not been implemented.');
   }

   Future<String> getAssetDetail() {
     throw UnimplementedError('getAssetId() has not been implemented.');
   }


   Future<void> setDefaultConfig({required DefaultConfig config}) {
     throw UnimplementedError('setDefaultConfig() has not been implemented.');
   }

   Future<String> getDefaultConfig() {
     throw UnimplementedError('getDefaultConfig() has not been implemented.');
   }

   Future<void> setAndroidNotificationConfig({required AndroidNotificationConfig config}) {
     throw UnimplementedError('setAndroidNotificationConfig() has not been implemented.');
   }

   Future<String> getAndroidNotificationConfig() {
     throw UnimplementedError('getAndroidNotificationConfig() has not been implemented.');
   }

   Future<void> setIOSNotificationConfig({required IOSNotificationConfig config}) {
     throw UnimplementedError('setIOSNotificationConfig() has not been implemented.');
   }

   Future<String> getIOSNotificationConfig() {
     throw UnimplementedError('getIOSNotificationConfig() has not been implemented.');
   }

   Future<void> updateLocationConfig({required LocationConfig config}) {
     throw UnimplementedError('updateLocationConfig() has not been implemented.');
   }


   Future<void> setLocationConfig({required LocationConfig config}) {
     throw UnimplementedError('setLocationConfig() has not been implemented.');
   }

   Future<void> setDataTrackingConfig({required DataTrackingConfig config}) {
     throw UnimplementedError('setDataTrackingConfig() has not been implemented.');
   }

   Future<String> getDataTrackingConfig() {
     throw UnimplementedError('getDataTrackingConfig() has not been implemented.');
   }

   Future<String> getLocationConfig() {
     throw UnimplementedError('getLocationConfig() has not been implemented.');
   }

   Future<void> setFakeGpsConfig({required bool allow}) {
     throw UnimplementedError('setFakeGpsConfig() has not been implemented.');
   }

   Future<String> getFakeGpsConfig() {
     throw UnimplementedError('getFakeGpsConfig() has not been implemented.');
   }

   Future<String> isTracking() {
     throw UnimplementedError('isTracking() has not been implemented.');
   }

   Future<String> createAsset({required AssetProfile profile}) {
     throw UnimplementedError('createAsset() has not been implemented.');
   }

   Future<String> bindAsset({String? customId}) {
     throw UnimplementedError('bindAsset() has not been implemented.');
   }

   Future<String> forceBindAsset({String? customId}) {
     throw UnimplementedError('forceBindAsset() has not been implemented.');
   }

  Future<void> startTracking() {
    throw UnimplementedError('startTracking() has not been implemented.');
  }

   Future<void> stopTracking() {
     throw UnimplementedError('stopTracking() has not been implemented.');
   }

   Future<String> startTrip({required TripProfile profile}) {
     throw UnimplementedError('startTrip() has not been implemented.');
   }

   Future<String> endTrip() {
     throw UnimplementedError('endTrip() has not been implemented.');
   }

   Future<String> getTrip({required String tripId}) {
     throw UnimplementedError('getTrip() has not been implemented.');
   }

   Future<String> updateTrip({required TripUpdateProfile profile}) {
     throw UnimplementedError('getTrip() has not been implemented.');
   }

   Future<String> getSummary({required String tripId}) {
     throw UnimplementedError('getSummary() has not been implemented.');
   }

   Future<String> deleteTrip({required String tripId}) {
     throw UnimplementedError('deleteTrip() has not been implemented.');
   }

   Future<String> getActiveTripId() {
     throw UnimplementedError('getActiveTripId() has not been implemented.');
   }

   Future<String> isTripInProgress() {
     throw UnimplementedError('isTripInProgress() has not been implemented.');
   }

}
