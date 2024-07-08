//
//  TripStatus.swift
//  nb_asset_tracking_flutter
//
//  Created by qiu on 2024/7/5.
//
import NBAssetTracking
import Foundation

extension TripStatus {
    var name: String {
            switch self {
            case .started:
                return "started"
            case .end:
                return "ended"
            case .updated:
                return "updated"
            case .deleted:
                return "deleted"
            @unknown default:
                return ""
            }
        }
}
