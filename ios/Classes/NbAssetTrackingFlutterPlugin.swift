import Flutter
import UIKit
import NBAssetTracking
import CoreLocation

public class NbAssetTrackingFlutterPlugin: NSObject, FlutterPlugin {
    private static var channel: FlutterMethodChannel? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "nb_asset_tracking_flutter", binaryMessenger: registrar.messenger())
        let instance = NbAssetTrackingFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let assetTracking = AssetTracking.shared
        switch call.method {
        case "initialize":
            assetTracking.delegate = self
            if let accessKey = call.arguments as? String {
                assetTracking.initialize(apiKey: accessKey)
                result(AssetResult(success: true, data: accessKey, msg: "").toJson())
            }else {
                result(AssetResult(success: false, data: "", msg: "").toJson())
            }
        case "setKeyOfHeaderField":
            if let header = call.arguments as? String {
                assetTracking.initialize(apiKey: header)
                result(AssetResult(success: true, data: header, msg: "").toJson())
            }else {
                result(AssetResult(success: false, data: "", msg: "").toJson())
            }
        case "getAssetId":
            let assetId = assetTracking.getAssetId()
            result(AssetResult(success: true, data: assetId, msg: "").toJson())
            
        case "getAssetDetail":
            assetTracking.getAssetDetail(completionHandler: {response in
                let json = Convert.toJson(T: response)
                result(AssetResult(success: true, data: json, msg: "").toJson())
                
            }, errorHandler: { error in
                result(AssetResult(success: false, data: String(error.errorCode), msg: error.message).toJson())
            })
        case "updateAsset":
            if let profileJson = call.arguments as? String,
               let assetProfile: UpdateAssetProfile = Convert.decodeAssetUpdateProfileJson(profileJson: profileJson) {
                assetTracking.updateAsset(assetProfile: assetProfile, completionHandler: {unit in
                    result(AssetResult(success: true, data: "", msg: "").toJson())
                }, errorHandler: {error in
                    result(AssetResult(success: false, data: String(error.errorCode), msg: error.message).toJson())
                })
            }
        case "setIOSNotificationConfig":
            if let configJson = call.arguments as? String,
               let data = Convert.decodeNotificationConfigJson(configJson: configJson) {
                assetTracking.setNotificationConfig(config: data)
                result(AssetResult(success: true, data: "", msg: "").toJson())
            }else {
                result(AssetResult(success: false, data: "", msg: "Data decode failure").toJson())
            }
            
        case "getIOSNotificationConfig":
            let notificationConfig = assetTracking.getNotificationConfig()
            let nofigicationJson = Convert.toJson(T: notificationConfig)
            result(AssetResult(success: true, data: nofigicationJson, msg: "").toJson())
            
        case "updateLocationConfig" :
            if let configJson = call.arguments as? String,
               let data = Convert.decodeLocationConfigJson(locationJson: configJson) {
                assetTracking.updateLocationConfig(config: data)
                result(AssetResult(success: true, data: "", msg: "").toJson())
            } else {
                result(AssetResult(success: false, data: "", msg: "Data decode failure").toJson())
            }
            
        case "setLocationConfig":
            if let configJson = call.arguments as? String,
               let data = Convert.decodeLocationConfigJson(locationJson: configJson) {
                assetTracking.setLocationConfig(config: data)
                result(AssetResult(success: true, data: "", msg: "").toJson())
            } else {
                result(AssetResult(success: false, data: "", msg: "Data decode failure").toJson())
            }
            
        case "getLocationConfig":
            let locationConfig = assetTracking.getLocationConfig()
            result(AssetResult(success: true, data: Convert.encodeLocationConfig(config: locationConfig), msg: "").toJson())

        case "setDataTrackingConfig":
            if let configJson = call.arguments as? String,
               let data = Convert.decodeDataTrackingConfigJson(configJson: configJson) {
                assetTracking.setDataTrackingConfig(config: data)
                result(AssetResult(success: true, data: "", msg: "").toJson())
            }
            
        case "getDataTrackingConfig":
            let dataTrackingConfig = assetTracking.getDataTrackingConfig()
            let assetResult = AssetResult(success: true, data: Convert.toJson(T: dataTrackingConfig), msg: "")
            result(assetResult.toJson())
            
        case "isTracking":
            let isTracking = assetTracking.isRunning()
            result(AssetResult(success: true, data: isTracking, msg: "").toJson())

        case "createAsset":
            if let profileJson = call.arguments as? String,
               let assetProfile = Convert.decodeAssetProfileJson(profileJson: profileJson) {
                assetTracking.createAsset(assetProfile: assetProfile, completionHandler: {assetId in
                    result(AssetResult(success: true, data: assetId, msg: "").toJson())
                }, errorHandler: {error in
                    result(AssetResult(success: false, data: String(error.errorCode), msg: error.message).toJson())
                })
            }else {
                result(AssetResult(success: false, data: "", msg: "Data decode failure").toJson())
            }
        case "bindAsset":
            if let assetId = call.arguments as? String {
                assetTracking.bindAsset(assetId: assetId, completionHandler: {code in
                    result(AssetResult(success: true, data: assetId, msg: "").toJson())
                    
                }, errorHandler: {error in
                    result(AssetResult(success: false, data: String(error.errorCode), msg: error.message).toJson())
                    
                })
            }else {
                result(AssetResult(success: false, data: "", msg: "Data decode failure").toJson())
            }
        case "forceBindAsset":
            if let assetId = call.arguments as? String {
                assetTracking.forceBindAsset(assetId: assetId, completionHandler: {code in
                    result(AssetResult(success: true, data: String(code), msg: "").toJson())
                    
                }, errorHandler: {error in
                    result(AssetResult(success: false, data: String(error.errorCode), msg: error.message).toJson())
                })
            } else {
                result(AssetResult(success: false, data: "", msg: "No assetId seted").toJson())
            }
            
        case "startTracking":
            assetTracking.startTracking()
            result(AssetResult(success: true, data: "", msg: "").toJson())
            
        case "stopTracking":
            assetTracking.stopTracking()
            result(AssetResult(success: true, data: "", msg: "").toJson())
            
        case "setFakeGpsConfig":
            if let allow = call.arguments as? Bool {
                if #available(iOS 15.0, *) {
                    assetTracking.setAllowFakeGps(allow: allow)
                    result(AssetResult(success: true, data: "", msg: "").toJson())
                    return
                }
            }
            result(AssetResult(success: false, data: "", msg: "Value convert failure").toJson())
            
        case "getFakeGpsConfig":
            let allow = assetTracking.isAllowFakeGps()
            result(AssetResult(success: true, data: allow, msg: "").toJson())

        case "startTrip":
            if let profileJson = call.arguments as? String,
               let profile = Convert.decodeTripProfileJson(profileJson: profileJson) {
                assetTracking.startTrip(tripProfile: profile) { tripId in
                    result(AssetResult(success: true, data: tripId, msg: "").toJson())
                } errorHandler: { error in
                    result(AssetResult(success: false, data: "", msg: error.message).toJson())
                }

            } else {
                result(AssetResult(success: false, data: "", msg: "TripProfile decode falure").toJson())
            }
            break
        case "endTrip":
            assetTracking.endTrip { tripId in
                result(AssetResult(success: true, data: tripId, msg: "").toJson())
            } errorHandler: { error in
                result(AssetResult(success: false, data: "", msg: error.message).toJson())
            }
           break
        case "getTrip":
            if let tripId = call.arguments as? String ,!tripId.isEmpty {
                assetTracking.getTrip(tripId: tripId) { trip in
                    result(AssetResult(success: true, data: trip, msg: "").toJson())
                } errorHandler: { error in
                    result(AssetResult(success: false, data: "", msg: error.message).toJson())
                }
            } else {
                result(AssetResult(success: false, data: "", msg: "Trip ID is nil or Empty").toJson())
            }
           break
        case "updateTrip":
            if let profileJson = call.arguments as? String,
               let profile = Convert.decodeUpdateTripProfileJson(profileJson: profileJson) {
                assetTracking.updateTrip(tripId: nil, tripProfile: profile) { tripId in
                    result(AssetResult(success: true, data: tripId, msg: "").toJson())
                } errorHandler: { error in
                    result(AssetResult(success: false, data: "", msg: error.message).toJson())
                }

            } else {
                result(AssetResult(success: false, data: "UpdateTripProfile decode falure", msg: "").toJson())
            }
           break
        case "getSummary":
            if let tripId = call.arguments as? String ,!tripId.isEmpty {
                assetTracking.tripSummaray(tripId: tripId) { summary in
                    result(AssetResult(success: true, data: summary, msg: "").toJson())
                } errorHandler: { error in
                    result(AssetResult(success: false, data: "", msg: error.message).toJson())
                }
            } else {
                result(AssetResult(success: false, data: "", msg: "Trip ID is nil or empty.").toJson())
            }
            break
        case "deleteTrip":
            if let tripId = call.arguments as? String,!tripId.isEmpty{
                assetTracking.deleteTrip(tripId: tripId) { tripId in
                    result(AssetResult(success: true, data: tripId, msg: "").toJson())
                } errorHandler: { error in
                    result(AssetResult(success: false, data: error.message, msg: error.message).toJson())
                }

            } else {
                result(AssetResult(success: false, data:"Trip ID is nil or empty.", msg: "").toJson())
            }
           break
        case "getActiveTripId":
            if let tripId =  assetTracking.getActiveTripId() {
                result(AssetResult(success: true, data: tripId, msg: "").toJson())
            } else {
                result(AssetResult(success: false, data: "", msg: "No active trip ID").toJson())
            }
            
           break
  
        case "isTripInProgress":
            let isInProgress = assetTracking.isTripInProgress()
            result(AssetResult(success: true, data: isInProgress, msg: "").toJson())
           break

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension NbAssetTrackingFlutterPlugin: AssetTrackingDelegate {
    public func onTripStatusChanged(tripId: String, status: NBAssetTracking.TripStatus) {
        // Create a dictionary with tripId and status
        let data = ["tripId": tripId, "status": status.name]
           
        // Create an AssetResult instance
        let result = AssetResult(success: true, data: data, msg: "")
           
        // Convert the AssetResult instance to JSON
        let jsonResult = result.toJson()
           
        // Invoke the Flutter method with the JSON result
        NbAssetTrackingFlutterPlugin.channel?.invokeMethod("onTripStatusChanged", arguments: jsonResult)
    }
    
    public func onTrackingStart(assetId: String) {
        NbAssetTrackingFlutterPlugin.channel?.invokeMethod("onTrackingStart", arguments: AssetResult(success: true, data: assetId, msg: "").toJson())
    }
    
    public func onTrackingStop(assetId: String, trackingDisableType: NBAssetTracking.TrackingDisableType) {
        NbAssetTrackingFlutterPlugin.channel?.invokeMethod("onTrackingStop", arguments: AssetResult(success: true, data: assetId, msg: "").toJson())
    }
    
    public func onLocationSuccess(location: CLLocation) {
        NbAssetTrackingFlutterPlugin.channel?.invokeMethod("onLocationSuccess", arguments: AssetResult(success: true, data: Convert.convertLocationToMap(location: location), msg: "").toJson())

    }
    
    public func onLocationFailure(error: Error) {
        NbAssetTrackingFlutterPlugin.channel?.invokeMethod("onLocationFailure", arguments: AssetResult(success: false, data: error.localizedDescription, msg: error.localizedDescription).toJson())

    }
    
    public func onLocationServiceOff() {
        
    }
    
    
}
