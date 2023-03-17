import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // WorkmanagerPlugin
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*1))
    WorkmanagerPlugin.registerTask(withIdentifier: "task-identifier")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}