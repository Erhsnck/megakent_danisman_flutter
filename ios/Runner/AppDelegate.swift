import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Yerel bildirim izin talebi (APK'deki POST_NOTIFICATIONS karşılığı)
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    center.requestAuthorization(
      options: [.alert, .sound, .badge, .provisional],
      completionHandler: { granted, error in
        if let error = error {
          print("Bildirim hatası: \(error.localizedDescription)")
        } else {
          print("Bildirim izni: \(granted)")
        }
      }
    )

    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Bildirim açıldığında çağrılır (iOS 10+)
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }

  // Uygulama açıkken bildirim gösterimi (iOS 10+)
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([[.banner, .sound]])
  }
}
