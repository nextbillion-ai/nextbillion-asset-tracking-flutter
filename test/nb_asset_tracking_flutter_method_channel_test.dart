import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNbAssetTrackingFlutter platform = MethodChannelNbAssetTrackingFlutter();
  const MethodChannel channel = MethodChannel('nb_asset_tracking_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
