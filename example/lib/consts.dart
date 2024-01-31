
import 'dart:io';

const keyOfBoundId = "key_of_bind_id";
const keyOfFakeGpsFlag = "key_of_fake_gps_flag";
const keyOfEnableTrackingStartedNotification = "key_of_enable_tracking_started_notification";
const keyOfEnableTrackingStopNotification = "key_of_enable_tracking_stop_notification";
const keyOfTrackingMode = "key_of_tracking_mode";

const keyOfEnvConfig = "key_of_evn_config";

var baseUrlProd = Platform.isAndroid ? "https://api.nextbillion.io" : "api.nextbillion.io";
var baseUrlStaging = Platform.isAndroid ? "https://sgpstg.nextbillion.io" : "sgpstg.nextbillion.io";

enum EnvConfig {
  prod,
  staging;

  static EnvConfig fromString(String s) => switch (s) {
    "prod" => prod,
    "staging" => staging,
    _ => prod
  };
}

enum CustomIntervalMode {
  timeBased,
  distanceBased;
}