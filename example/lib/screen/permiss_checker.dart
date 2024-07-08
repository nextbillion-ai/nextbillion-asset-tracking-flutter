import 'package:permission_handler/permission_handler.dart';

Future<bool> checkLocationPermission() async {
  var status = await Permission.location.status;
  if (status.isGranted) {
    return true;
  }
  return false;
}

Future<bool> checkAndRequestLocationPermission() async {

  var status = await Permission.location.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    status = await Permission.location.request();
    return status.isGranted;
  } else if (status.isPermanentlyDenied) {
    // 如果永久被拒绝，打开应用设置
    openAppSettings();
    return false;
  }
  return false;
}