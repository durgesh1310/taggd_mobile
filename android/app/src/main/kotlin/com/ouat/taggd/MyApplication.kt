package com.ouat.taggd

import android.app.Application
import android.content.IntentFilter
import com.netcore.android.logger.SMTDebugLevel
import com.smartech.flutter.smartech_plugin.DeeplinkReceivers
import com.smartech.flutter.smartech_plugin.SmartechPlugin
import io.flutter.app.FlutterApplication

class MyApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        SmartechPlugin.initializePlugin(this)
        //val smartech = Smartech.getInstance(WeakReference(this))
        //smartech.initializeSdk(this)
        SmartechPlugin.setDebugLevel(SMTDebugLevel.Level.VERBOSE)
        SmartechPlugin.trackAppInstallUpdateBySmartech()

        val deeplinkReceiver = DeeplinkReceivers()
        val filter = IntentFilter("com.smartech.EVENT_PN_INBOX_CLICK")
        registerReceiver(deeplinkReceiver, filter)
    }

}