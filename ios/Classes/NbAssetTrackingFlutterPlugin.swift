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
            if let accessKey = call.arguments as? String {
                assetTracking.initialize(apiKey: accessKey)
                result(AssetResult(success: true, data: accessKey, msg: "").toJson())
            }
        case "getAssetId":
            let assetId = assetTracking.getAssetId()
            result(AssetResult(success: true, data: assetId, msg: "").toJson())
            
        case "getAssetDetail":
            assetTracking.getAssetDetail(completionHandler: {response in
                result(AssetResult(success: true, data: Convert.toJson(T: response.data), msg: "").toJson())
                
            }, errorHandler: { error in
                result(AssetResult(success: false, data: String(error.errorCode), msg: error.message).toJson())
            })
        case "setIOSNotificationConfig":
            if let configJson = call.arguments as? String,
               let data = Convert.decodeNotificationConfigJson(configJson: configJson) {
                assetTracking.setNotificationConfig(config: data)
                result(AssetResult(success: true, data: "", msg: "").toJson())
            }
            
        case "geIOSNotificationConfig":
            let notificationConfig = assetTracking.getNotificationConfig()
            let nofigicationJson = Convert.toJson(T: notificationConfig)
            result(AssetResult(success: true, data: nofigicationJson, msg: "").toJson())
            
        case "updateLocationConfig" :
            if let configJson = call.arguments as? String,
               let data = Convert.decodeLocationConfigJson(locationJson: configJson) {
                assetTracking.updateLocationConfig(config: data)
                result(AssetResult(success: true, data: "", msg: "").toJson())
            }
            
        case "setLocationConfig":
            if let configJson = call.arguments as? String,
               let data = Convert.decodeLocationConfigJson(locationJson: configJson) {
                assetTracking.setLocationConfig(config: data)
                result(AssetResult(success: true, data: "", msg: "").toJson())
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
            result(isTracking)
            
        case "createAsset":
            if let profileJson = call.arguments as? String,
               let assetProfile = Convert.decodeAssetProfileJson(profileJson: profileJson) {
                assetTracking.createAsset(assetProfile: assetProfile, completionHandler: {createResponse in
                    result(AssetResult(success: true, data: createResponse.data.id, msg: "").toJson())
                }, errorHandler: {error in
                    result(AssetResult(success: false, data: String(error.errorCode), msg: error.message).toJson())
                })
            }
        case "bindAsset":
            if let assetId = call.arguments as? String {
                assetTracking.bindAsset(assetId: assetId, completionHandler: {code in
                    result(AssetResult(success: true, data: assetId, msg: "").toJson())
                    
                }, errorHandler: {error in
                    result(AssetResult(success: false, data: String(error.errorCode), msg: error.message).toJson())
                    
                })
            }
        case "forceBindAsset":
            if let assetId = call.arguments as? String {
                assetTracking.forceBindAsset(assetId: assetId, completionHandler: {code in
                    result(AssetResult(success: true, data: String(code), msg: "").toJson())
                    
                }, errorHandler: {error in
                    result(AssetResult(success: false, data: String(error.errorCode), msg: error.message).toJson())
                })
            }
            
        case "startTracking":
            assetTracking.delegate = self
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
                }
            }
            
        case "getFakeGpsConfig":
            let allow = assetTracking.isAllowFakeGps()
            result(AssetResult(success: true, data: allow, msg: "").toJson())

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension NbAssetTrackingFlutterPlugin: AssetTrackingCallback {
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
