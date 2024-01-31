package ai.nextbillion.nb_asset_tracking_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.app.Activity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


/** NbAssetTrackingFlutterPlugin */
class NbAssetTrackingFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware{
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var methodHandler: MethodHandler

    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "nb_asset_tracking_flutter")
        methodHandler = MethodHandler(channel)
        channel.setMethodCallHandler(this)

    }


    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        activity?.let {
            methodHandler.addDataListener(activity!!)
        }

    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        if (activity != null) {
            methodHandler.removeDataListener(activity!!)
        }

        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        methodHandler.dispatchMethodHandler(activity,call,result)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        methodHandler.deInit()
    }
}
