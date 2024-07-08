//
//  Convert.swift
//  nb_asset_tracking_flutter
//
//  Created by qiuyu on 2024/1/8.
//

import Foundation
import NBAssetTracking
import CoreLocation

let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""

class Convert {
    
    static func decodeLocationConfigJson(locationJson: String) -> LocationConfig? {
        do {
            let jsonData = locationJson.data(using: .utf8)
            var jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!) as! [String:Any]
            
            if let trackingMode = jsonDictionary["trackingMode"] as? String {
                if(trackingMode == "active") {
                    return LocationConfig(trackingMode: TrackingMode.ACTIVE)
                } else if (trackingMode == "balanced") {
                    return LocationConfig(trackingMode: TrackingMode.BALANCED)
                } else if (trackingMode == "passive") {
                    return LocationConfig(trackingMode: TrackingMode.PASSIVE)
                } else {
                    let desiredAccuracy = jsonDictionary["desiredAccuracy"] as! String
                    var accuracy = kCLLocationAccuracyBest
                    if (desiredAccuracy == "high") {
                        accuracy = kCLLocationAccuracyBest
                    } else if (desiredAccuracy == "medium") {
                        accuracy = kCLLocationAccuracyNearestTenMeters
                    } else if (desiredAccuracy == "low") {
                        accuracy = kCLLocationAccuracyHundredMeters
                    }
                    return LocationConfig(distanceFilter: jsonDictionary["smallestDisplacement"] as! CLLocationDistance, desiredAccuracy: accuracy, enableStationaryCheck: jsonDictionary["enableStationaryCheck"] as! Bool)
                }
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    static func encodeLocationConfig(config: LocationConfig) -> String {
        var trackingMode = "active"
        switch config.trackingMode {
        case .ACTIVE:
            trackingMode = "active"
        case .BALANCED:
            trackingMode = "balanced"
        case .PASSIVE:
            trackingMode = "passive"
        case nil:
            trackingMode = "custom"
        case .some(_):
            trackingMode = "custom"
        }

        var accuracy = config.desiredAccuracy
        var desiredAccuracy = "high"
        if(accuracy <= kCLLocationAccuracyBest) {
            desiredAccuracy = "high"
        } else if(accuracy <= kCLLocationAccuracyNearestTenMeters) {
            desiredAccuracy = "medium"
        } else {
            desiredAccuracy = "low"
        }
        
        
        let jsonMap: [String: Any] = [
            "trackingMode": trackingMode,
            "smallestDisplacement": config.distanceFilter,
            "desiredAccuracy": desiredAccuracy,
            "enableStationaryCheck": config.enableStationaryCheck
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonMap, options: .fragmentsAllowed)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
    
    
    static func decodeDataTrackingConfigJson(configJson: String) -> DataTrackingConfig? {
        do {
            let jsonData = configJson.data(using: .utf8)
            let data = try JSONDecoder().decode(DataTrackingConfig.self, from: jsonData!)
            return data
        } catch {
            return nil
        }
    }
    
    static func decodeNotificationConfigJson(configJson: String) -> NotificationConfig? {
        do {
            let jsonData = configJson.data(using: .utf8)
            let data = try JSONDecoder().decode(NotificationConfig.self, from: jsonData!)
            let titleEnable = data.assetEnableNotificationConfig.title
            let titleDisEnable = data.assetDisableNotificationConfig.title
            let titleLowBattery = data.lowBatteryNotificationConfig.title
            if(titleEnable.isEmpty) {
                data.assetEnableNotificationConfig.title = appName
            }
            if(titleDisEnable.isEmpty) {
                data.assetDisableNotificationConfig.title = appName
            }
            if(titleLowBattery.isEmpty) {
                data.lowBatteryNotificationConfig.title = appName
            }
            return data
        } catch {
            return nil
        }
    }
    
    static func decodeAssetProfileJson(profileJson: String) -> AssetProfile? {
        do {
            let jsonData = profileJson.data(using: .utf8)
            var jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!) as! [String:Any]
            jsonDictionary["assetDescription"] = jsonDictionary["description"]
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            let assetProfile = try JSONDecoder().decode(AssetProfile.self, from: data) as AssetProfile
            return assetProfile
        } catch {
            return nil
        }
    }
    
    static func decodeAssetUpdateProfileJson(profileJson: String) -> UpdateAssetProfile? {
        do {
            let jsonData = profileJson.data(using: .utf8)
            var jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!) as! [String:Any]
            jsonDictionary["assetDescription"] = jsonDictionary["description"]
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            let assetProfile = try JSONDecoder().decode(UpdateAssetProfile.self, from: data) as UpdateAssetProfile
            return assetProfile
        } catch {
            return nil
        }
    }
    
    static func convertLocationToMap(location: CLLocation) -> String {
        let locationMap: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "accuracy": location.horizontalAccuracy,
            "altitude": location.altitude,
            "speed": location.speed,
            "speedAccuracy": location.speedAccuracy,
            "heading": location.course,
            "timestamp": Int(location.timestamp.timeIntervalSince1970)
        ]

        do {
            if let jsonData = try? JSONSerialization.data(withJSONObject: locationMap),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            } else {
                return ""
            }
        }
    }
    
    static func toJson(T: Codable) -> String {
        do {
            let jsonData = try JSONEncoder().encode(T)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                throw NSError(domain: "JsonEncodingError", code: 0, userInfo: nil)
            }
            return jsonString
        } catch {
            return ""
        }
    }
    
    static func decodeTripProfileJson(profileJson: String) -> TripProfile? {
        do {
            let jsonData = profileJson.data(using: .utf8)
            var jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!) as! [String:Any]
            jsonDictionary["tripDescription"] = jsonDictionary["description"]
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            let tripProfile = try JSONDecoder().decode(TripProfile.self, from: data) as TripProfile
            return tripProfile
        } catch {
            return nil
        }
    }
    
    static func decodeUpdateTripProfileJson(profileJson: String) -> UpdateTripProfile? {
        do {
            let jsonData = profileJson.data(using: .utf8)
            var jsonDictionary = try JSONSerialization.jsonObject(with: jsonData!) as! [String:Any]
            jsonDictionary["tripDescription"] = jsonDictionary["description"]
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            let tripProfile = try JSONDecoder().decode(UpdateTripProfile.self, from: data) as UpdateTripProfile
            return tripProfile
        } catch {
            return nil
        }
    }
    
}
