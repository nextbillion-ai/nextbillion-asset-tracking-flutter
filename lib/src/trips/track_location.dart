import 'trip_location.dart';

class TrackLocation {
  final double? accuracy;
  final double? altitude;
  final double? bearing;
  final TripLocation? location;
  final Map<String, dynamic>? metaData;
  final double? speed;
  final DateTime? timestamp;
  final int batteryLevel;
  final String? trackingMode;

  TrackLocation({
    this.accuracy,
    this.altitude,
    this.bearing,
    this.location,
    this.metaData,
    this.speed,
    required this.timestamp,
    required this.batteryLevel,
    required this.trackingMode,
  });

  // Factory constructor to create an instance from JSON
  factory TrackLocation.fromJson(Map<String, dynamic> json) {
    int?  timestamp = json['timestamp'];
    return TrackLocation(
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      bearing: (json['bearing'] as num?)?.toDouble(),
      location: json['location'] != null ? TripLocation.fromJson(json['location']) : null,
      metaData: json['meta_data'] as Map<String, dynamic>?,
      speed: (json['speed'] as num?)?.toDouble(),
      timestamp: timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000): null,
      batteryLevel: json['battery_level'],
      trackingMode: json['tracking_mode'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'accuracy': accuracy,
      'altitude': altitude,
      'bearing': bearing,
      'location': location?.toJson(),
      'meta_data': metaData,
      'speed': speed,
      'timestamp': timestamp,
      'battery_level': batteryLevel,
      'tracking_mode': trackingMode,
    };
  }
}
