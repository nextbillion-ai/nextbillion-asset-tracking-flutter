package ai.nextbillion.nb_asset_tracking_flutter

import ai.nextbillion.assettracking.*
import ai.nextbillion.assettracking.callback.AssetTrackingCallBack
import ai.nextbillion.assettracking.entity.FakeGpsConfig
import ai.nextbillion.assettracking.entity.TrackingDisableType
import ai.nextbillion.assettracking.entity.TripStatus
import ai.nextbillion.assettracking.extension.log
import ai.nextbillion.network.AssetApiCallback
import ai.nextbillion.network.AssetException
import ai.nextbillion.network.get.Asset
import ai.nextbillion.network.create.AssetCreationResponse
import ai.nextbillion.network.get.GetAssetResponse
import ai.nextbillion.network.trip.TripProfile
import ai.nextbillion.network.trip.entity.Trip
import ai.nextbillion.network.trip.entity.TripSummary
import android.app.Activity
import android.location.Location
import android.text.TextUtils
import com.google.gson.Gson
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodHandler(private val channel: MethodChannel) :
    AssetTrackingCallBack {

    fun addDataListener(activity: Activity) {
        activity.assetTrackingAddCallback(this)
        System.out.println("check demo addDataListener")
    }

    fun removeDataListener(activity: Activity) {
        activity.assetTrackingRemoveCallback(this)
        System.out.println("check demo removeDataListener")
    }

    fun dispatchMethodHandler(
        activity: Activity?,
        call: MethodCall?,
        methodResult: MethodChannel.Result?,
    ) {
        if (null == call || null == methodResult) {
            return
        }
        if (activity == null) {
            methodResult.success(
                AssetResult(
                    success = false,
                    data = "",
                    msg = "Activity have not attached"
                )
            )
            return
        }

        val method = call.method
        if (TextUtils.isEmpty(method)) {
            return
        }
        when (call.method) {
            "initialize" -> {
                val key = call.arguments as String
                // Initialize with the key if necessary
                activity.initialize(key);
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }
            "setKeyOfHeaderField" -> {
                val key = call.arguments as String
                // Initialize with the key if necessary
                activity.setKeyOfRequestHeader(key);
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }

            "getAssetId" -> {
                val assetId = activity.getAssetId()
                methodResult.success(AssetResult(success = true, assetId, msg = "").toJson())
            }

            "getAssetDetail" -> {
                activity.getAssetInfo(object : AssetApiCallback<GetAssetResponse> {

                    override fun onSuccess(result: GetAssetResponse) {
                        val asset: Asset = result.data.asset
                        val assetJsonString = Gson().toJson(asset)
                        methodResult.success(
                            AssetResult(
                                success = true,
                                assetJsonString,
                                msg = ""
                            ).toJson()
                        )
                    }

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                exception.errorCode,
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }
                })
            }

            "getDefaultConfig" -> {
                val config = activity.assetTrackingGetDefaultConfig()
                methodResult.success(AssetResult(success = true, config, msg = "").toJson())
            }

            "setAndroidNotificationConfig" -> {
                val string = call.arguments as String
                val config = ConfigConverter.notificationConfigFromJson(string)
                activity.assetTrackingSetNotificationConfig(config)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }

            "geAndroidNotificationConfig" -> {
                val config = activity.assetTrackingGetNotificationConfig()
                val json = ConfigConverter.notificationConfigToJson(config)
                methodResult.success(AssetResult(success = true, json, msg = "").toJson())
            }

            "updateLocationConfig" -> {
                val string = call.arguments as String
                val config = ConfigConverter.locationConfigFromJson(string)
                activity.assetTrackingUpdateLocationConfig(config)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }

            "setLocationConfig" -> {
                val map = call.arguments as String
                val config = ConfigConverter.locationConfigFromJson(map)
                activity.assetTrackingSetLocationConfig(config)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }

            "getLocationConfig" -> {
                val config = activity.assetTrackingGetLocationConfig()
                val json = ConfigConverter.locationConfigToJson(config)
                methodResult.success(AssetResult(success = true, json, msg = "").toJson())
            }

            "setDataTrackingConfig" -> {
                val string = call.arguments as String
                val config = ConfigConverter.dataTrackingConfigFromJson(string)
                activity.assetTrackingSetDataTrackingConfig(config)
                methodResult.success(AssetResult(success = true, "", msg = "").toJson())
            }

            "getDataTrackingConfig" -> {
                val config = activity.assetTrackingGetDataTrackingConfig()
                val map = ConfigConverter.dataTrackingConfigToJson(config)
                methodResult.success(AssetResult(success = true, map, msg = "").toJson())
            }

            "isTracking" -> {
                methodResult.success(
                    AssetResult(
                        success = true,
                        activity.assetTrackingIsRunning,
                        msg = ""
                    ).toJson()
                )
            }

            "createAsset" -> {
                val profileString = call.arguments as String
                val profile = ConfigConverter.assetProfileFromJson(profileString)
                activity.createNewAsset(profile, object : AssetApiCallback<AssetCreationResponse> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        val errorCode = exception.errorCode
                        methodResult.success(
                            AssetResult(
                                success = false,
                                errorCode.toString(),
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: AssetCreationResponse) {
                        methodResult.success(
                            AssetResult(
                                success = true,
                                result.data.id,
                                msg = result.toString()
                            ).toJson()
                        )
                    }
                })
            }

            "bindAsset" -> run {
                val assetId = call.arguments as String
                activity.bindAsset(assetId, object : AssetApiCallback<Unit> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                exception.errorCode.toString(),
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: Unit) {
                        methodResult.success(
                            AssetResult(
                                success = true,
                                assetId,
                                msg = result.toString()
                            ).toJson()
                        )
                    }
                })
            }

            "forceBindAsset" -> {
                val assetId = call.arguments as String
                activity.forceBindAsset(assetId, object : AssetApiCallback<Unit> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                exception.errorCode.toString(),
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: Unit) {
                        methodResult.success(
                            AssetResult(
                                success = true,
                                result.toString(),
                                msg = result.toString()
                            ).toJson()
                        )
                    }
                })
            }

            "startTracking" -> {
                activity.assetTrackingStart()
                methodResult.success(
                    AssetResult(
                        success = true,
                        "",
                        msg = ""
                    ).toJson()
                )
            }

            "stopTracking" -> {
                activity.assetTrackingStop()
                methodResult.success(
                    AssetResult(
                        success = true,
                        "",
                        msg = ""
                    ).toJson()
                )
            }

            "setFakeGpsConfig" -> {
                val allow = call.arguments as Boolean
                activity.assetTrackingUpdateFakeGpsConfig(FakeGpsConfig(allow))
                methodResult.success(
                    AssetResult(
                        success = true,
                        "",
                        msg = ""
                    ).toJson()
                )
            }

            "getFakeGpsConfig" -> {
                val allow = activity.assetTrackingGetFakeGpsConfig()
                methodResult.success(
                    AssetResult(
                        success = true,
                        allow.allowUseVirtualLocation,
                        msg = ""
                    ).toJson()
                )
            }

            "startTrip" -> {
                val profileString = call.arguments as String
                val profile = ConfigConverter.tripProfileFromJson(profileString)
                activity.assetTrackingStartTrip(profile, true, object : AssetApiCallback<String> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                null,
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: String) {
                        methodResult.success(
                            AssetResult(
                                success = true,
                                result,
                                msg = result
                            ).toJson()
                        )
                    }
                })
            }

            "endTrip" -> {
                activity.assetTrackingEndTrip(object : AssetApiCallback<String> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                null,
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: String) {
                        methodResult.success(
                            AssetResult(
                                success = true,
                                result,
                                msg = null
                            ).toJson()
                        )
                    }
                })
            }

            "getTrip" -> {
                val tripId = call.arguments as String
                activity.assetTrackingGetTripInfo(tripId, object : AssetApiCallback<Trip> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                null,
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: Trip) {
                        println("check demo getTrip: $result")
                        val json = ConfigConverter.tripToJson(result)
                        println("check demo json: $json")
                        methodResult.success(
                            AssetResult(
                                success = true,
                                result,
                                msg = ""
                            ).toJson()
                        )
                    }
                })

            }

            "updateTrip" -> {
                val profileString = call.arguments as String
                val profile = ConfigConverter.tripUpdateProfileFromJson(profileString)
                activity.assetTrackingUpdateTrip( profile, object : AssetApiCallback<String> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                null,
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: String) {
                        methodResult.success(
                            AssetResult(
                                success = true,
                                result,
                                msg = ""
                            ).toJson()
                        )
                    }
                })

            }
            "getSummary" -> {
                val tripId = call.arguments as String
                activity.assetTrackingTripSummary( tripId, object : AssetApiCallback<TripSummary> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                null,
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: TripSummary) {
                        methodResult.success(
                            AssetResult(
                                success = true,
                                result,
                                msg = ""
                            ).toJson()
                        )
                    }
                })

            }
            "deleteTrip" -> {
                val tripId = call.arguments as String
                activity.assetTrackingDeleteTrip( tripId, object : AssetApiCallback<String> {

                    override fun onFailure(exception: AssetException) {
                        val exceptionMessage = exception.message ?: ""
                        methodResult.success(
                            AssetResult(
                                success = false,
                                null,
                                msg = exceptionMessage
                            ).toJson()
                        )
                    }

                    override fun onSuccess(result: String) {
                        methodResult.success(
                            AssetResult(
                                success = true,
                                result,
                                msg = ""
                            ).toJson()
                        )
                    }
                })

            }
            "getActiveTripId" -> {
                activity.assetTrackingTripId()?.let {
                    methodResult.success(
                        AssetResult(
                            success = true,
                            it,
                            msg = ""
                        ).toJson()
                    )
                } ?: methodResult.success(
                    AssetResult(
                        success = false,
                        null,
                        msg = "No active trip"
                    ).toJson()
                )
            }
            "isTripInProgress" -> {
                activity.assetTrackingIsTripInProgress.let {
                    methodResult.success(
                        AssetResult(
                            success = true,
                            it,
                            msg = ""
                        ).toJson()
                    )
                }
            }
            else -> methodResult.notImplemented()
        }
    }

    override fun onLocationFailure(exception: Exception) {
        channel.invokeMethod(
            "check demo onLocationFailure", AssetResult(
                success = true,
                exception.message,
                msg = exception.message
            ).toJson()
        )
    }

    override fun onLocationSuccess(location: Location) {
        channel.invokeMethod(
            "onLocationSuccess", AssetResult(
                success = true,
                ConfigConverter.convertLocationToMap(location),
                msg = ""
            ).toJson()
        )
    }

    override fun onTrackingStart(assetId: String) {
        channel.invokeMethod(
            "onTrackingStart", AssetResult(
                success = true,
                assetId,
                msg = ""
            ).toJson()
        )
    }

    override fun onTrackingStop(assetId: String, trackingDisableType: TrackingDisableType) {
        channel.invokeMethod(
            "onTrackingStop", AssetResult(
                success = true,
                assetId,
                msg = trackingDisableType.name
            ).toJson()
        )
    }

    override fun onTripStatusChanged(tripId: String, status: TripStatus) {
        channel.invokeMethod(
            "onTripStatusChanged", AssetResult(
                success = true,
                mapOf("tripId" to tripId, "status" to status.name).toString(),
                msg = null
            ).toJson()
        )
    }

    fun deInit() {

    }

}