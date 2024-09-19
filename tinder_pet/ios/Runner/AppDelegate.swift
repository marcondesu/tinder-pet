import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey(dotenv.env['GOOGLE_MAPS_IOS_API_KEY'] ?? "")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
