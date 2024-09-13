import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey("AIzaSyC7Xwb9MF_RAy5QFqw08u2_mGJda8vzTWo")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
