import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter_example/screen/trip_storege.dart';
import 'package:nb_asset_tracking_flutter_example/screen/trip_summary_screen.dart';



class TripHistoryScreen extends StatefulWidget {

  const TripHistoryScreen({super.key});

  @override
  TripHistoryScreenState createState() => TripHistoryScreenState();
}

class TripHistoryScreenState extends State<TripHistoryScreen> {
  List<String>? tripHistory;

  @override
  void initState() {
    super.initState();
    getHistoryList().then((value) {
      setState(() {
        tripHistory = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
      ),
      body: tripHistory == null || tripHistory!.isEmpty ? const Center(child: Text("No ended trip"),): ListView.builder(
        itemCount: tripHistory?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tripHistory![index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TripSummaryScreen(tripId: tripHistory![index])),
              );
            },
          );
        },
      ),
    );
  }
}
