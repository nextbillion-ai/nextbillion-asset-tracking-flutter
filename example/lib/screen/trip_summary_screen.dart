import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/screen/time_format.dart';

import '../util/toast_mixin.dart';

class TripSummaryScreen extends StatefulWidget {
  final String tripId;

  const TripSummaryScreen({super.key, required this.tripId});

  @override
  TripSummaryScreenState createState() => TripSummaryScreenState();
}

class TripSummaryScreenState extends State<TripSummaryScreen> with ToastMixin {
  TripSummary? tripSummary;
  String errorMessage = 'Fetching data...';

  @override
  void initState() {
    super.initState();
    AssetTracking().getSummary(tripId: widget.tripId).then((value) {
      setState(() {
        if (value.success) {
          tripSummary = value.data;
        } else {
          showToast(value.msg ?? "");
          errorMessage = value.msg ?? "";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Summary'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: tripSummary == null
              ? Center(
                  child: Text(errorMessage),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${tripSummary!.id}',
                        style: const TextStyle(fontSize: 18)),
                    Text('Asset ID: ${tripSummary!.assetId}',
                        style: const TextStyle(fontSize: 18)),
                    Text('State: ${tripSummary!.state}',
                        style: const TextStyle(fontSize: 18)),
                    Text('Name: ${tripSummary!.name}',
                        style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.description != null)
                      Text('Description: ${tripSummary!.description}',
                          style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.metaData != null)
                      Text('Meta Data: ${tripSummary!.metaData.toString()}',
                          style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.attributes != null)
                      Text('Attributes: ${tripSummary!.attributes.toString()}',
                          style: const TextStyle(fontSize: 18)),
                    Text('Started At: ${timeFormat(tripSummary!.startedAt)}',
                        style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.endedAt != null)
                      Text('Ended At: ${timeFormat(tripSummary!.endedAt)}',
                          style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.createdAt != null)
                      Text('Created At: ${timeFormat(tripSummary!.createdAt)}',
                          style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.updatedAt != null)
                      Text('Updated At: ${timeFormat(tripSummary!.updatedAt)}',
                          style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.stops != null) ...[
                      const Text('Stops:', style: TextStyle(fontSize: 18)),
                      ...tripSummary!.stops!
                          .map((stop) => Text(stop.toString(),
                              style: const TextStyle(fontSize: 18)))
                          .toList(),
                    ],
                    if (tripSummary!.route != null) ...[
                      const Text('Route:', style: TextStyle(fontSize: 18)),
                      ...tripSummary!.route!
                          .map((location) => Text(location.toString(),
                              style: const TextStyle(fontSize: 18)))
                          .toList(),
                    ],
                    Text('Asset: ${tripSummary!.asset.toString()}',
                        style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.geometry != null)
                      Text('Geometry: ${tripSummary!.geometry.toString()}',
                          style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.distance != null)
                      Text('Distance: ${tripSummary!.distance}',
                          style: const TextStyle(fontSize: 18)),
                    if (tripSummary!.duration != null)
                      Text('Duration: ${tripSummary!.duration}',
                          style: const TextStyle(fontSize: 18)),
                  ],
                ),
        ),
      ),
    );
  }
}
