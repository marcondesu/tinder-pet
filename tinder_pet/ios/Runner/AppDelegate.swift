import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey("AIzaSyCc_AeYP6sT0XG-vUFj_DxTTj989fg3UpQ")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
