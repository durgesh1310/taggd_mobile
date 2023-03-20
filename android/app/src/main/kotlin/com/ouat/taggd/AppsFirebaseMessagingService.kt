package com.ouat.taggd
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.smartech.flutter.smartech_plugin.SmartechPlugin


class AppsFirebaseMessagingService : FirebaseMessagingService() {

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        SmartechPlugin.setDevicePushToken(token)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        SmartechPlugin.handlePushNotification(remoteMessage.data.toString())
    }
}