import 'nb_location.dart';

class NativeResultCallback {
  void Function(NBLocation)? onLocationSuccess;
  void Function(String)? onLocationFailure;
  void Function(String)? onTrackingStart;
  void Function(String)? onTrackingStop;

  NativeResultCallback({
    this.onLocationSuccess,
    this.onLocationFailure,
    this.onTrackingStart,
    this.onTrackingStop,
  });
}
