import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle notification tap when app is in foreground or background
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    if let payload = userInfo["payload"] as? String {
      print("Notification payload: \(payload)")
      // Handle payload (e.g., navigate to a specific screen)
    }
    completionHandler()
  }
}
