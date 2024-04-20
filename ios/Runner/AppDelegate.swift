import UIKit
import Flutter
import YandexMapsMobile
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() // Инициализация Firebase
    YMKMapKit.setApiKey("75862ae7-2e48-40ca-9388-149dedc5314f") // Установка API ключа Yandex Maps
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
