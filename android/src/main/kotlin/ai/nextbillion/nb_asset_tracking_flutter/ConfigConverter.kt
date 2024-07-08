package ai.nextbillion.nb_asset_tracking_flutter

import ai.nextbillion.assettracking.entity.DataTrackingConfig
import ai.nextbillion.assettracking.entity.LocationConfig
import ai.nextbillion.assettracking.entity.LowBatteryNotificationConfig
import ai.nextbillion.assettracking.entity.NotificationConfig
import ai.nextbillion.assettracking.location.engine.DesiredAccuracy
import ai.nextbillion.assettracking.location.engine.TrackingMode
import ai.nextbillion.network.AssetProfile
import android.location.Location
import com.google.gson.Gson
import org.json.JSONObject
import ai.nextbillion.network.trip.TripProfile
import ai.nextbillion.network.trip.TripUpdateProfile
import ai.nextbillion.network.trip.entity.Trip
import ai.nextbillion.network.trip.entity.TripSummary

object ConfigConverter {

    fun notificationConfigFromJson(jsonString: String): NotificationConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, NotificationConfig::class.java)
    }

    fun notificationConfigToJson(config: NotificationConfig): String {
        val gson = Gson()
        return gson.toJson(config, NotificationConfig::class.java)
    }

    fun batteryConfigFromJson(jsonString: String): LowBatteryNotificationConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, LowBatteryNotificationConfig::class.java)
    }

    fun batteryConfigToJson(config: LowBatteryNotificationConfig): String {
        val gson = Gson()
        return gson.toJson(config, LowBatteryNotificationConfig::class.java)
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

        val desiredAccuracy:DesiredAccuracy = when (json["desiredAccuracy"]) {
            "high" -> {
                DesiredAccuracy.HIGH
            }

            "medium" -> {
                DesiredAccuracy.BALANCED
            }

            "low" -> {
                DesiredAccuracy.LOW
            }
            else -> {
                DesiredAccuracy.HIGH
            }
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
                    desiredAccuracy = desiredAccuracy,
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

        val desiredAccuracy: String = when (config.desiredAccuracy) {
            DesiredAccuracy.HIGH -> {
                "high"
            }

            DesiredAccuracy.BALANCED -> {
                "medium"
            }

            DesiredAccuracy.LOW -> {
                "low"
            }

            else -> {
                "high"
            }
        }

        val map = mapOf(
            "trackingMode" to trackingMode,
            "interval" to config.interval,
            "smallestDisplacement" to config.smallestDisplacement,
            "maxWaitTime" to config.maxWaitTime,
            "fastestInterval" to config.fastestInterval,
            "enableStationaryCheck" to config.enableStationaryCheck,
            "desiredAccuracy" to desiredAccuracy,
        )
        return gson.toJson(map, Map::class.java)
    }

    fun dataTrackingConfigFromJson(jsonString: String): DataTrackingConfig {
        val gson = Gson()
        return gson.fromJson(jsonString, DataTrackingConfig::class.java)
    }

    fun dataTrackingConfigToJson(config: DataTrackingConfig): String {
        val gson = Gson()
        return gson.toJson(config, DataTrackingConfig::class.java)
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

    fun tripProfileFromJson(json: String): TripProfile {
        val gson = Gson()
        return gson.fromJson(json, TripProfile::class.java)
    }

    fun tripUpdateProfileFromJson(json: String): TripUpdateProfile {
        val gson = Gson()
        return gson.fromJson(json, TripUpdateProfile::class.java)
    }

    fun tripToJson(trip: Trip): String {
        val gson = Gson()
        return gson.toJson(trip);
    }

    fun summaryToJson(summary: TripSummary): String {
        val gson = Gson()
        return gson.toJson(summary, TripSummary::class.java)
    }


}