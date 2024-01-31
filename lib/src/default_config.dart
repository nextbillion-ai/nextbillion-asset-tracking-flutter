import 'dart:convert';

import 'nb_encode.dart';

class DefaultConfig with NBEncode {
  bool enhanceService;
  int repeatInterval;
  bool workerEnabled;
  bool crashRestartEnabled;
  bool workOnMainThread;

  DefaultConfig({
    required this.enhanceService,
    required this.repeatInterval,
    required this.workerEnabled,
    required this.crashRestartEnabled,
    required this.workOnMainThread,
  });


  factory DefaultConfig.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return DefaultConfig(
      enhanceService: json['enhanceService'] as bool,
      repeatInterval: json['repeatInterval'] as int,
      workerEnabled: json['workerEnabled'] as bool,
      crashRestartEnabled: json['crashRestartEnabled'] as bool,
      workOnMainThread: json['workOnMainThread'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'enhanceService': enhanceService,
      'repeatInterval': repeatInterval,
      'workerEnabled': workerEnabled,
      'crashRestartEnabled': crashRestartEnabled,
      'workOnMainThread': workOnMainThread,
    };
  }
}
