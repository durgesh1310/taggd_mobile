import UIKit
import Flutter
import Smartech
import Firebase
import UserNotifications
import UserNotificationsUI
import AppsFlyerLib
import smartech_flutter_plugin

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SmartechDelegate, AppsFlyerLibDelegate{
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        
    }
    
    func onConversionDataFail(_ error: Error) {
        
    }
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
      Smartech.sharedInstance().setDebugLevel(.verbose)
    UNUserNotificationCenter.current().delegate = self
    Smartech.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
    return true
  }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Smartech.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
  }
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    Smartech.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
  }

  //MARK:- UNUserNotificationCenterDelegate Methods
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    Smartech.sharedInstance().willPresentForegroundNotification(notification)
    completionHandler([.alert, .badge, .sound])
  }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    Smartech.sharedInstance().didReceive(response)
    completionHandler()
  }
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andCustomPayload customPayload: [AnyHashable : Any]?) {
        SwiftSmartechPlugin.handleDeeplinkAction(withURLString: deeplinkURLString, andCustomPayload: customPayload)
            }
    
}

