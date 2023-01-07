import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications
import workmanager
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  if #available(iOS 10.0, *) {
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
  }
      GMSServices.provideAPIKey("AIzaSyCxMAiyFG-l2DUifjrksWErZFk_gZ8mTEk")
      UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
       WorkmanagerPlugin.registerTask(withIdentifier: "fetchBackground")
      FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}