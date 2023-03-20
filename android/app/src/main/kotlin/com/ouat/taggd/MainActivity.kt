package com.ouat.taggd
import android.os.Bundle;
import androidx.annotation.NonNull;
//import com.ouat.taggd.RazorpayDelegate
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import android.content.Intent
import com.ouat.taggd.RazorpayPlugin
import com.smartech.flutter.smartech_plugin.DeeplinkReceivers
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        DeeplinkReceivers().onReceive(this, intent)
    }
    override fun onNewIntent(intent : Intent){
        super.onNewIntent(intent)
        setIntent(intent)
    }

}

