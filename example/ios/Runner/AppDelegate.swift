import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
        GeneratedPluginRegistrant.register(with: self)
        
        let navigationController = UINavigationController(rootViewController: flutterViewController)
        
        navigationController.setNavigationBarHidden(true, animated: false)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window.rootViewController = navigationController
        self.window.isHidden = false

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
