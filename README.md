
## Introduction

The Nextbillion.AI Asset Tracking Flutter plugin is designed to enable developers to integrate location tracking functionality into their Android or iOS applications. It facilitates real-time tracking of assets, allowing data to be uploaded to the Nextbillion.AI backend or a custom database.

## Key Features and Capabilities
* Asset create
* Bind asset
* Location information callback
* Tracking status callback
* Start and stop tracking function
* Asset details retrieve

## Getting Started
### Prerequisites
Before integrating the SDK into your application, ensure that your development environment meets the following prerequisites:

**Access Key**: To utilize Nextbillion.ai's Flutter Asset Tracking SDK, developers must obtain an access key, which serves as the authentication mechanism for accessing the SDK's features and functionalities.

**Platform Requirements:**
Android: The minimum supported Android SDK version for using the Flutter Asset Tracking SDK is API level 21 (Android 5.0, "Lollipop") or higher.
iOS: The SDK is compatible with iOS 11 or later versions.

**Flutter Compatibility:** The Flutter Asset Tracking SDK requires Flutter version 3.3.0 or higher to ensure seamless integration and optimal performance with the Flutter framework.

**CocoaPods:** For iOS projects, the SDK requires CocoaPods version 1.11.3 or newer to manage dependencies effectively and ensure proper integration with iOS projects.

### Installation
To use this library, add the following dependency to your pubspec.yaml file:
```
dependencies:    
  nb_asset_tracking_flutter: ^<version_number>
```
Replace <version_number> with the desired version of the library.For the latest version, please check out the [Flutter Asset Tracking Plugin]()

### Required Permissions
To ensure the proper functioning of NextBillion.ai's Flutter Asset Tracking SDK, you need to grant location permissions and declare them for both Android and iOS platforms.
#### Android
```
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

The **ACCESS_FINE_LOCATION** and **ACCESS_COARSE_LOCATION** and **ACCESS_BACKGROUND_LOCATION** permissions allow the app to access the user's location, 
The FOREGROUND_SERVICE permission is necessary for background location updates and Foreground services.
And the **INTERNET** permission allows the app to access the internet.

#### iOS
###### Getting Location Access
The *NSLocationWhenInUseUsageDescription* and *NSLocationAlwaysUsageDescription* keys must be defined in your **Info.plist** file, which is located in the *Runner* folder of your Flutter project. These keys give users a clear and concise explanation of why your app requires access to their location data. This proactive approach promotes transparency and trust among your app's users.
```
<key>NSLocationWhenInUseUsageDescription</key>
<string>[Your explanation here]</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>[Your explanation here]</string>
```

Replace `[Your explanation here]` with a brief but informative description of why your app requires access to the user's location data. This description should clearly communicate the value that users will receive by granting this access.

###### Enabling Background Location Updates

The *UIBackgroundModes* key must be defined to enable location updates even when your app is running in the background. The location value is specified within this key, indicating that your app intends to use background location services. In addition, an audio mode is included to ensure that your app continues to receive location updates while audio services are active.
```
<key>UIBackgroundModes</key>
<array>
<string>location</string>
<string>audio</string>
</array>
```

This setting enables your app to keep accurate location data even when it is not actively in the foreground, resulting in a more seamless user experience for location-based functionalities.

By configuring these elements meticulously within your **Info.plist** file, you ensure that your application complies with privacy regulations, respects user preferences, and provides the best possible experience when utilizing location-based features, both in the foreground and background.

### Usage
#### 1.Import the necessary classes:
`import 'package:nb_asset_tracking_flutter/asset_tracking.dart';`

#### 2.Create an instance of AssetTracking:

`AssetTracking assetTracking = AssetTracking();`

#### 3.Initialize the library with your API key:
`await assetTracking.initialize(apiKey: '<your_api_key>');`

#### 4. Start using the provided methods to manage assets, track locations, and configure notifications.
```
// Create an asset
AssetResult<String> assetResult = await assetTracking.createAsset(profile: assetProfile);
// Bind an asset
AssetResult<String> bindResult = await assetTracking.bindAsset(customId: '<custom_id>');
// Start tracking
await assetTracking.startTracking();
// Get asset details
AssetResult<Map> assetDetails = await assetTracking.getAssetDetail();
// Stop tracking
await assetTracking.stopTracking();
```


### Custom Configurations
#### 1. Default Configuration(Optional)
Create a default configuration object if you want to customize default settings:
```
DefaultConfig defaultConfig = DefaultConfig(); 
await assetTracking.setDefaultConfig(config: defaultConfig);
 ```

#### 2. Android Notification Configuration(Optional)
Customize Android notification settings if needed:
```
AndroidNotificationConfig androidConfig = AndroidNotificationConfig();
await assetTracking.setAndroidNotificationConfig(config: androidConfig);
```
#### 3. iOS Notification Configuration(Optional)
Configure iOS notification settings based on your requirements:
```
IOSNotificationConfig iosConfig = IOSNotificationConfig();
await assetTracking.setIOSNotificationConfig(config: iosConfig);
```

#### 4. Location Configuration(Optional)
Adjust location tracking settings according to your preferences:
```
LocationConfig locationConfig = LocationConfig();
await assetTracking.setLocationConfig(config: locationConfig);
```
#### 5. Data Tracking Configuration(Optional)
Customize data tracking settings if required:
```
DataTrackingConfig dataTrackingConfig = DataTrackingConfig();
await assetTracking.setDataTrackingConfig(config: dataTrackingConfig);
```
### Event Listeners
Register listeners to receive updates:
```

class ConcreteTrackingListener implements OnTrackingDataCallBack {
  @override
  void onLocationSuccess(NBLocation location) {
    print('Location update successful: $location');
    // Handle successful location update logic here
  }

  @override
  void onLocationFailure(String message) {
    print('Location update failed: $message');
    // Handle location update failure logic here
  }

  @override
  void onTrackingStart(String assetId) {
    print('Tracking started for asset: $assetId');
    // Handle tracking start logic here
  }

  @override
  void onTrackingStop(String assetId) {
    print('Tracking stopped for asset: $assetId');
    // Handle tracking stop logic here
  }
}

// Create an instance of the concrete listener
ConcreteTrackingListener concreteListener = ConcreteTrackingListener();
  
// Add a listener
assetTracking.addDataListener(concreteListener);

// Remove a listener
assetTracking.removeDataListener(concreteListener);
```

#### License
This library is licensed under the MIT License.

Feel free to customize the README to better fit your documentation style and include additional details as needed.










