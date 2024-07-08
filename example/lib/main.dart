import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter_example/screen/feature_list.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      home: const FeatureListScreen(),
    ),
  );
}
