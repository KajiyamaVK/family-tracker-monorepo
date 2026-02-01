import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyB_JCxSDCZKDZyqsmsTkDW1L75id0ufCik")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
