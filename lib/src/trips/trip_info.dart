import 'trip_stop.dart';
import 'track_location.dart';

class TripInfo {
  final String id;
  final String assetId;
  final String state;
  final String name;
  final String? description;
  final Map<String, dynamic>? metaData;
  final Map<String, dynamic>? attributes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<TripStop>? stops;
  final List<TrackLocation>? route;

  TripInfo({
    required this.id,
    required this.assetId,
    required this.state,
    required this.name,
    this.description,
    this.metaData,
    this.attributes,
    required this.startedAt,
    this.endedAt,
    required this.createdAt,
    this.updatedAt,
    this.stops,
    this.route,
  });

  // Factory constructor to create an instance from JSON
  factory TripInfo.fromJson(Map<String, dynamic> json) {
    int  createdTime = json['created_at'];
    int?  endedTime = json['ended_at'];
    int?  updatedTime = json['updated_at'];
    int  startedTime = json['started_at'];
    return TripInfo(
      id: json['id'] ?? '',
      assetId: json['asset_id'] ?? '',
      state: json['state'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      metaData: json['meta_data'] != null ? Map<String, dynamic>.from(json['meta_data']) : null,
      attributes: json['attributes'] != null ? Map<String, dynamic>.from(json['attributes']) : null,
      startedAt: DateTime.fromMillisecondsSinceEpoch(startedTime * 1000),
      endedAt: endedTime != null ? DateTime.fromMillisecondsSinceEpoch(endedTime * 1000): null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdTime * 1000),
      updatedAt: updatedTime != null ? DateTime.fromMillisecondsSinceEpoch(updatedTime * 1000) : null,
      stops: json['stops'] != null
          ? (json['stops'] as List).map((item) => TripStop.fromJson(item)).toList()
          : null,
      route: json['route'] != null
          ? (json['route'] as List).map((item) => TrackLocation.fromJson(item)).toList()
          : null,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asset_id': assetId,
      'state': state,
      'name': name,
      'description': description,
      'meta_data': metaData,
      'attributes': attributes,
      'started_at': startedAt,
      'ended_at': endedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'stops': stops?.map((item) => item.toJson()).toList(),
      'route': route?.map((item) => item.toJson()).toList(),
    };
  }
}