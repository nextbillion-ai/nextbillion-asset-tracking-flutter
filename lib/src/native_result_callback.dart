import 'nb_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_state.dart';

class NativeResultCallback {
  void Function(NBLocation)? onLocationSuccess;
  void Function(String)? onLocationFailure;
  void Function(String)? onTrackingStart;
  void Function(String)? onTrackingStop;
  void Function(String,TripState)? onTripStatusChanged;

  NativeResultCallback({
    this.onLocationSuccess,
    this.onLocationFailure,
    this.onTrackingStart,
    this.onTrackingStop,
    this.onTripStatusChanged,

  });
}
