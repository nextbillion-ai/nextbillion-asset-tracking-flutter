import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';


class CurrentTripInfoScreen extends StatefulWidget {
  final String tripId;

  const CurrentTripInfoScreen({super.key, required this.tripId});

  @override
  TripInfoScreenState createState() => TripInfoScreenState();
}

class TripInfoScreenState extends State<CurrentTripInfoScreen> {
  Future<TripInfo>? _tripInfoFuture;

  @override
  void initState() {
    super.initState();
    _tripInfoFuture = _fetchTripInfo();
  }

  Future<TripInfo> _fetchTripInfo() async {
    AssetResult result = await AssetTracking().getTrip(tripId: widget.tripId);
    if(result.success) {
      return result.data;
    } else {
      throw Exception(result.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Information'),
      ),
      body: FutureBuilder<TripInfo>(
        future: _tripInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No Trip Info Found'));
          }

          TripInfo tripInfo = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text('ID: ${tripInfo.id}', style: const TextStyle(fontSize: 18)),
                Text('Asset ID: ${tripInfo.assetId}', style: const TextStyle(fontSize: 18)),
                Text('State: ${tripInfo.state}', style: const TextStyle(fontSize: 18)),
                Text('Name: ${tripInfo.name}', style: const TextStyle(fontSize: 18)),
                if (tripInfo.description != null)
                  Text('Description: ${tripInfo.description}', style: const TextStyle(fontSize: 18)),
                Text('Started At: ${tripInfo.startedAt.toLocal().toString()}', style: const TextStyle(fontSize: 18)),
                if (tripInfo.endedAt != null)
                  Text('Ended At: ${tripInfo.endedAt?.toLocal().toString()}', style: const TextStyle(fontSize: 18)),
                Text('Created At: ${tripInfo.createdAt.toLocal().toString()}', style: const TextStyle(fontSize: 18)),
                if (tripInfo.updatedAt != null)
                  Text('Updated At: ${tripInfo.updatedAt?.toLocal().toString()}', style: const TextStyle(fontSize: 18)),
                if (tripInfo.stops != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Stops:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ...tripInfo.stops!.map((stop) => Text('Stop: ${stop.name}')),
                    ],
                  ),
                if (tripInfo.route != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Route:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ...tripInfo.route!.map((location) => Text('Location: ${location.location?.lat}, ${location.location?.lon}')),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
