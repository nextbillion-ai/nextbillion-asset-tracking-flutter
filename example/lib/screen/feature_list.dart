import 'package:flutter/material.dart';
import 'package:nb_asset_tracking_flutter_example/model/feature_model.dart';
import 'package:nb_asset_tracking_flutter_example/screen/asset_profile_screen.dart';
import 'package:nb_asset_tracking_flutter_example/screen/home_screen.dart';
import 'package:nb_asset_tracking_flutter_example/screen/simple_tracking.dart';
import 'package:nb_asset_tracking_flutter_example/screen/update_tracking_configuration.dart';

class FeatureListScreen extends StatefulWidget {
  @override
  FeatureListScreenState createState() => new FeatureListScreenState();
}

class FeatureListScreenState extends State<FeatureListScreen> {
  List<FeatureModel> features = [];

  @override
  void initState() {
    super.initState();
    features.add(FeatureModel("Full Asset Tracking Example", "Comprehensive Example of asset tracking"));
    features.add(FeatureModel("Simple Tracking Example", "A simple tracking example of the Plugin integration"));
    features.add(FeatureModel(
        "Asset Profile Operation Example", "Asset Profile related operation example of the Plugin integration"));
    features.add(
        FeatureModel("Update Tracking Configuration Example", "Example of updating the tracking related configuration"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return _buildFeatureItem(index);
        },
      ),
    );
  }

  _buildFeatureItem(int index) {
    FeatureModel featureModel = features[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const HomeScreen();
              }),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return SimpleTrackingExample();
              }),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return AssetProfileScreen();
              }),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return UpdateConfigurationExample();
              }),
            );
            break;
          case 4:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              featureModel.title,
              style: TextStyle(fontSize: 15),
            ),
            Text(
              featureModel.subTitle,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Visibility(visible:index == 0, child: Divider()),
            )
          ],
        ),
      ),
    );
  }
}
