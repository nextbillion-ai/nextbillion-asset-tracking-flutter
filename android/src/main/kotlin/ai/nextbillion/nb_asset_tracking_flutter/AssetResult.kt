package ai.nextbillion.nb_asset_tracking_flutter

import com.google.gson.Gson

data class AssetResult<T>(
    val success: Boolean,
    val data: T?,
    val msg: String?
) {
    companion object {
        // Create a new instance of AssetResult from JSON
        fun <T> fromJson(json: Map<String, Any>, dataClass: Class<T>): AssetResult<T> {
            val gson = Gson()
            val jsonData = gson.toJson(json["data"])
            val data: T = gson.fromJson(jsonData, dataClass)

            return AssetResult(
                success = json["success"] as Boolean,
                data = data,
                msg = json["msg"] as String?
            )
        }
    }

    // Convert an AssetResult instance to JSON
    fun toJson(): String {
        val gson = Gson()
        return gson.toJson(this)

    }
}
