import 'package:flutter/material.dart';
import 'home_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      home: const HomeScreen(),
    ),
  );
}
