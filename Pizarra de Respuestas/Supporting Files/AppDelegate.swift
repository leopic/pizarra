import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setupNavBar()
    setupLogging()
    return true
  }

  private func setupNavBar() -> Void {
    UINavigationBar.appearance().tintColor = Color.secondary
    UINavigationBar.appearance().barTintColor = Color.blackboard
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: Color.primary,
      NSAttributedString.Key.font: Fonts.h2
    ]
    UINavigationBar.appearance().largeTitleTextAttributes = [
      NSAttributedString.Key.foregroundColor: Color.primary,
      NSAttributedString.Key.font: Fonts.h1
    ]
    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Fonts.h3
    ], for: .normal)
  }

  private func setupLogging() -> Void {
    let logger = Logger.shared
  }

  // MARK: UISceneSession Lifecycle

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

}
