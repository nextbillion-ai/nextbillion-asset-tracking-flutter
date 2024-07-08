import 'package:nb_asset_tracking_flutter/src/trips/track_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_asset.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_stop.dart';

class TripSummary {
  final String id;
  final String assetId;
  final String state;
  final String name;
  final String? description;
  final Map<String, dynamic>? metaData;
  final Map<String, dynamic>? attributes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<TripStop>? stops;
  final List<TrackLocation>? route;
  final TripAsset asset;
  final List<String>? geometry;
  final double? distance;
  final double? duration;

  TripSummary({
    required this.id,
    required this.assetId,
    required this.state,
    required this.name,
    this.description,
    this.metaData,
    this.attributes,
    required this.startedAt,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
    this.stops,
    this.route,
    required this.asset,
    this.geometry,
    this.distance,
    this.duration,
  });

  // Factory constructor to create an instance from JSON
  factory TripSummary.fromJson(Map<String, dynamic> json) {
    int createdTime = json['created_at'];
    int? endedTime = json['ended_at'];
    int? updatedTime = json['updated_at'];
    int startedTime = json['started_at'];

    return TripSummary(
      id: json['id'],
      assetId: json['asset_id'],
      state: json['state'],
      name: json['name'],
      description: json['description'],
      metaData: json['meta_data'] as Map<String, dynamic>?,
      attributes: json['attributes'] as Map<String, dynamic>?,
      startedAt: DateTime.fromMillisecondsSinceEpoch(startedTime * 1000),
      endedAt: endedTime == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(endedTime * 1000),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdTime * 1000),
      updatedAt: updatedTime == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(updatedTime * 1000),
      stops: (json['stops'] as List<dynamic>?)
          ?.map((stop) => TripStop.fromJson(stop))
          .toList(),
      route: (json['route'] as List<dynamic>?)
          ?.map((location) => TrackLocation.fromJson(location))
          .toList(),
      asset: TripAsset.fromJson(json['asset']),
      geometry: (json['geometry'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      distance: (json['distance'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
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
      'stops': stops?.map((stop) => stop.toJson()).toList(),
      'route': route?.map((location) => location.toJson()).toList(),
      'asset': asset.toJson(),
      'geometry': geometry,
      'distance': distance,
      'duration': duration,
    };
  }
}
