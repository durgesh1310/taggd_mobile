package com.ouat.taggd.plugins

import androidx.annotation.Keep
import com.ouat.taggd.RazorpayPlugin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.Log
import java.lang.Exception

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
object GeneratedPluginRegistrant {
    private const val TAG = "GeneratedPluginRegistrant"
    fun registerWith(flutterEngine: FlutterEngine) {
        try {
            flutterEngine.plugins.add(RazorpayPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin razorpay_flutter_customui, com.razorpay.flutter_customui.RazorpayPlugin", e)
        }
    }
}