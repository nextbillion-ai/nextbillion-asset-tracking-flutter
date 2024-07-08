

class TripLocation {
  final double lat;
  final double lon;

  TripLocation({
    required this.lat,
    required this.lon,
  });

  // Factory constructor to create an instance from JSON
  factory TripLocation.fromJson(Map<String, dynamic> json) {
    return TripLocation(
      lat: json['lat'] as double,
      lon: json['lon'] as double,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }
}
