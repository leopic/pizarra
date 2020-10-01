import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let os = "iOS \(ProcessInfo().operatingSystemVersion.majorVersion)"
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    let device = isiPad ? "iPad" : "iPhone"
    Logger.track.action("App launch: \(device), \(os)")

    setupNavBar()
    
    return true
  }

  private func setupNavBar() -> Void {
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().tintColor = Color.label
    UINavigationBar.appearance().barTintColor = Color.blackboard
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: Color.primary,
      NSAttributedString.Key.font: Fonts.h2
    ]
  }

  // MARK: UISceneSession Lifecycle

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

}
