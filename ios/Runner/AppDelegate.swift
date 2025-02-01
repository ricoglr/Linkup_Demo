import Firebase
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase'i başlatıyoruz
    FirebaseApp.configure()

    // Flutter plugin'lerini kaydediyoruz
    GeneratedPluginRegistrant.register(with: self)

    // Ana uygulama işlevine devam ediyoruz
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)

    // Firebase Analytics'i başlatıyoruz
    //Bu kod, uygulama her açıldığında Firebase’e app_open adlı bir etkinlik gönderir.
    Analytics.logEvent("app_open", parameters: nil)
  }
}
