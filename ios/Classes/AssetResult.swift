//
//  AssetResult.swift
//  nb_asset_tracking_flutter
//
//  Created by qiuyu on 2024/1/4.
//

import Foundation


struct AssetResult<T: Codable>: Codable {
    var success: Bool = false
    var data: T? = nil
    var msg: String? = ""

    
    func toJson() -> String {
        do {
            let jsonData = try JSONEncoder().encode(self)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                throw NSError(domain: "JsonEncodingError", code: 0, userInfo: nil)
            }
            return jsonString
        } catch {
            return ""
        }
    }
}

