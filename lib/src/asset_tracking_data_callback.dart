import '../nb_asset_tracking_flutter.dart';

abstract class OnTrackingDataCallBack {
  void onLocationSuccess(NBLocation location);
  void onLocationFailure(String message);
  void onTrackingStart(String message);
  void onTrackingStop(String message);
}