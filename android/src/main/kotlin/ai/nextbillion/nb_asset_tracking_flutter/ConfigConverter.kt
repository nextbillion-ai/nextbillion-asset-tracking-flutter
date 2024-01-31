package ai.nextbillion.nb_asset_tracking_flutter

import ai.nextbillion.assettracking.entity.DataTrackingConfig
import ai.nextbillion.assettracking.entity.LocationConfig
import ai.nextbillion.assettracking.entity.LowBatteryNotificationConfig
import ai.nextbillion.assettracking.entity.NotificationConfig
import ai.nextbillion.assettracking.location.engine.TrackingMode
import ai.nextbillion.network.AssetProfile
import android.location.Location
import com.google.gson.Gson
import org.json.JSONObject

object ConfigConverter {

    fun notificationConfigFromJson(jsonString: String): NotificationConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, NotificationConfig::class.java)

//            return NotificationConfig(
//                serviceId = (json["serviceId"] as? Int) ?: 10010,
//                channelId = (json["channelId"] as? String) ?: "NextBillion.AI",
//                channelName = (json["channelName"] as? String) ?: "NextBillion.AI",
//                title = (json["title"] as? String) ?: "Default Title",
//                content = (json["content"] as? String) ?: "Asset tracking start content",
//                smallIcon = (json["smallIcon"] as? Int) ?: 0,
//                largeIcon = (json["largeIcon"] as? Int) ?: 0,
//                showLowBatteryNotification = (json["showLowBatteryNotification"] as? Boolean) ?: true,
//                lowBatteryNotification = batteryConfigFromJson(json["lowBatteryNotificationConfig"] as Map<String, Any?>),
//                showAssetIdTakenNotification = (json["showAssetIdTakenNotification"] as? Boolean) ?: true,
//                contentAssetDisable = (json["contentAssetDisable"] as? String) ?: "Asset tracking stop content",
//                assetIdTakenContent = (json["assetIdTakenContent"] as? String) ?: "Asset ID taken content"
//            )
    }

    fun notificationConfigToJson(config: NotificationConfig): String {
        val gson = Gson()
        return gson.toJson(config, NotificationConfig::class.java)


//            return mapOf(
//                "serviceId" to config.serviceId,
//                "channelId" to config.channelId,
//                "channelName" to config.channelName,
//                "title" to config.title,
//                "content" to config.content,
//                "smallIcon" to config.smallIcon,
//                "largeIcon" to config.largeIcon,
//                "showLowBatteryNotification" to config.showLowBatteryNotification,
//                "lowBatteryNotificationConfig" to batteryConfigToJson(config.lowBatteryNotification),
//                "showAssetIdTakenNotification" to config.showAssetIdTakenNotification,
//                "contentAssetDisable" to config.contentAssetDisable,
//                "assetIdTakenContent" to config.assetIdTakenContent
//            )
    }

    fun batteryConfigFromJson(jsonString: String): LowBatteryNotificationConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, LowBatteryNotificationConfig::class.java)
//            return LowBatteryNotificationConfig(
//                threshold = ((json["threshold"] as? Number)?.toDouble() ?: throw IllegalArgumentException("Threshold is required")).toFloat(),
//                channelId = json["channelId"] as? String ?: throw IllegalArgumentException("ChannelId is required"),
//                channelName = json["channelName"] as? String ?: throw IllegalArgumentException("ChannelName is required"),
//                title = json["title"] as? String ?: throw IllegalArgumentException("Title is required"),
//                content = json["content"] as? String ?: throw IllegalArgumentException("Content is required"),
//                smallIcon = (json["smallIcon"] as? Int) ?: throw IllegalArgumentException("SmallIcon is required")
//            )
    }

    fun batteryConfigToJson(config: LowBatteryNotificationConfig): String {
        val gson = Gson()
        return gson.toJson(config, LowBatteryNotificationConfig::class.java)

//            return mapOf(
//                "threshold" to config.threshold,
//                "channelId" to config.channelId,
//                "channelName" to config.channelName,
//                "title" to config.title,
//                "content" to config.content,
//                "smallIcon" to config.smallIcon
//            )
    }

    fun locationConfigFromJson(jsonString: String): LocationConfig {
        val jsonObject = JSONObject(jsonString)
        val json = mutableMapOf<String, Any>()

        val keys = jsonObject.keys()
        while (keys.hasNext()) {
            val key = keys.next()
            val value = jsonObject.get(key)
            json[key] = value
        }

        when (json["trackingMode"]) {
            "active" -> {
                return LocationConfig(TrackingMode.ACTIVE)
            }
            "balanced" -> {
                return LocationConfig(TrackingMode.BALANCED)
            }
            "passive" -> {
                return LocationConfig(TrackingMode.PASSIVE)
            }
            else -> {
                return LocationConfig(
                    interval = (json["interval"] as Int).toLong(),
                    smallestDisplacement = (json["smallestDisplacement"] as Double).toFloat(),
                    maxWaitTime = (json["maxWaitTime"] as Int).toLong(),
                    fastestInterval = (json["fastestInterval"] as Int).toLong(),
                    enableStationaryCheck = json["enableStationaryCheck"] as Boolean,
                )
            }
        }
    }

    fun locationConfigToJson(config: LocationConfig): String {
        val gson = Gson()
        val trackingMode: String = when (config.trackingMode) {
            TrackingMode.ACTIVE -> {
                "active"
            }

            TrackingMode.BALANCED -> {
                "balanced"
            }

            TrackingMode.PASSIVE -> {
                "passive"
            }

            else -> {
                "custom"
            }
        }

        val map = mapOf(
            "trackingMode" to trackingMode,
            "interval" to config.interval,
            "smallestDisplacement" to config.smallestDisplacement,
            "maxWaitTime" to config.maxWaitTime,
            "fastestInterval" to config.fastestInterval,
            "enableStationaryCheck" to config.enableStationaryCheck,
        )
        return gson.toJson(map, Map::class.java)
    }

    fun dataTrackingConfigFromJson(jsonString: String): DataTrackingConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, DataTrackingConfig::class.java)

//            return DataTrackingConfig(
//                baseUrl = json["baseUrl"] as String,
//                dataStorageSize = json["dataStorageSize"] as Int,
//                dataUploadingBatchSize = json["dataUploadingBatchSize"] as Int,
//                dataUploadingBatchWindow = json["dataUploadingBatchWindow"] as Int,
//                shouldClearLocalDataWhenCollision = json["shouldClearLocalDataWhenCollision"] as Boolean
//            )
    }

    fun dataTrackingConfigToJson(config: DataTrackingConfig): String {
        val gson = Gson()
        return gson.toJson(config, DataTrackingConfig::class.java)

//            return mapOf(
//                "baseUrl" to config.baseUrl,
//                "dataStorageSize" to config.dataStorageSize,
//                "dataUploadingBatchSize" to config.dataUploadingBatchSize,
//                "dataUploadingBatchWindow" to config.dataUploadingBatchWindow,
//                "shouldClearLocalDataWhenCollision" to config.shouldClearLocalDataWhenCollision
//            )
    }

    fun assetProfileFromJson(json: String): AssetProfile {
        val gson = Gson()
        return gson.fromJson(json, AssetProfile::class.java)
    }

    fun assetProfileToJson(profile: AssetProfile): String {
        val gson = Gson()
        return gson.toJson(profile, AssetProfile::class.java)
    }

    fun convertLocationToMap(location: Location?): String {
        val locationMap = mutableMapOf<String, Any>()
        location?.let {
            locationMap["latitude"] = it.latitude
            locationMap["longitude"] = it.longitude
            locationMap["accuracy"] = it.accuracy.toDouble()
            locationMap["altitude"] = it.altitude
            locationMap["speed"] = it.speed.toDouble()
            locationMap["speedAccuracy"] = 0.0 // Android doesn't provide speed accuracy
            locationMap["heading"] = it.bearing.toDouble()
            locationMap["provider"] = it.provider ?: "Unknown"
            locationMap["timestamp"] = it.time ?: 0
        }
        val jsonObject = (locationMap as Map<*, *>?)?.let { JSONObject(it) }
        return jsonObject.toString()
    }

}