
class TripStop {
  final String name;
  final Map<String, dynamic>? metaData;
  final String geofenceId;

  TripStop({
    required this.name,
    this.metaData,
    required this.geofenceId,
  });
  // Factory constructor to create a TripStop from a JSON map
  factory TripStop.fromJson(Map<String, dynamic> json) {
    return TripStop(
      name: json['name'] as String,
      metaData: json['metaData'] != null ? Map<String, dynamic>.from(json['metaData']) : null,
      geofenceId: json['geofenceId'] as String,
    );
  }

  // Method to convert a TripStop to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'metaData': metaData,
      'geofenceId': geofenceId,
    };
  }
}
