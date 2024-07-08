

import 'package:nb_asset_tracking_flutter/src/trips/trip_last_location.dart';

class TripAsset {
  final String id;
  final String deviceId;
  final String state;
  final String name;
  final String description;
  final List<String>? tags;
  final Map<String, dynamic>? metaData;
  final double createdAt;
  final double? updatedAt;
  final Map<String, String>? attributes;
  final LatestLocation? latestLocation;

  TripAsset({
    required this.id,
    required this.deviceId,
    required this.state,
    required this.name,
    required this.description,
    this.tags,
    this.metaData,
    required this.createdAt,
    this.updatedAt,
    this.attributes,
    this.latestLocation,
  });
  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'state': state,
      'name': name,
      'description': description,
      'tags': tags,
      'meta_data': metaData,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'attributes': attributes,
      'latest_location': latestLocation?.toJson(),
    };
  }

  // Factory constructor to create an instance from JSON
  factory TripAsset.fromJson(Map<String, dynamic> json) {
    return TripAsset(
      id: json['id'],
      deviceId: json['device_id'],
      state: json['state'],
      name: json['name'],
      description: json['description'],
      tags: (json['tags'] as List<dynamic>?)?.map((tag) => tag as String).toList(),
      metaData: json['meta_data'] as Map<String, dynamic>?,
      createdAt: (json['created_at'] as num).toDouble(),
      updatedAt: (json['updated_at'] as num?)?.toDouble(),
      attributes: (json['attributes'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as String)),
      latestLocation: json['latest_location'] != null
          ? LatestLocation.fromJson(json['latest_location'])
          : null,
    );
  }

}
