import 'package:flutter_test/flutter_test.dart';
import 'package:nb_asset_tracking_flutter/src/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter/src/nb_asset_tracking_flutter_platform_interface.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNbAssetTrackingFlutterPlatform
    with MockPlatformInterfaceMixin
    implements NbAssetTrackingFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NbAssetTrackingFlutterPlatform initialPlatform = NbAssetTrackingFlutterPlatform.instance;

  test('$MethodChannelNbAssetTrackingFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNbAssetTrackingFlutter>());
  });

  test('getPlatformVersion', () async {
    NbAssetTrackingFlutter nbAssetTrackingFlutterPlugin = NbAssetTrackingFlutter();
    MockNbAssetTrackingFlutterPlatform fakePlatform = MockNbAssetTrackingFlutterPlatform();
    NbAssetTrackingFlutterPlatform.instance = fakePlatform;

    expect(await nbAssetTrackingFlutterPlugin.getPlatformVersion(), '42');
  });
}
