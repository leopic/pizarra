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
      NSAttributedString.Key.font: Fonts.title3
    ]

    UINavigationBar.appearance().largeTitleTextAttributes = [
      NSAttributedString.Key.foregroundColor: Color.primary,
      NSAttributedString.Key.font: Fonts.largeTitle
    ]

    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Fonts.headline
    ], for: .normal)

    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Fonts.headline
    ], for: .highlighted)
  }

  private func setupLogging() -> Void {
    _ = Logger.shared
  }

  // MARK: UISceneSession Lifecycle

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    connectingSceneSession.configuration
  }

}

// MARK: Restoration

extension AppDelegate {

  /** iOS 12.x
      Tells the delegate that the data for continuing an activity is available.
      Equivalent API for scenes is: scene(_:continue:)
  */
  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      return false // Not applicable here at the app delegate level.
  }

    // For non-scene-based versions of this app on iOS 13.1 and earlier.
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        true
    }

    // For non-scene-based versions of this app on iOS 13.1 and earlier.
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        true
    }

    @available(iOS 13.2, *)
    // For non-scene-based versions of this app on iOS 13.2 and later.
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        true
    }

    @available(iOS 13.2, *)
    // For non-scene-based versions of this app on iOS 13.2 and later.
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        true
    }

}
