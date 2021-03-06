import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity else { return }

    if configure(window: window, session: session, with: userActivity) {
      scene.userActivity = userActivity
      scene.title = userActivity.title

      if let sessionScreen = SceneDelegate.screen(for: userActivity) {
        session.userInfo = [
          SceneDelegate.screenIdKey: sessionScreen.id.rawValue,
          SceneDelegate.shouldShowSplashKey: false
        ]
      }
    } else {
      Swift.debugPrint("Failed to restore scene from \(userActivity)")
    }
  }

  func configure(window: UIWindow?, session: UISceneSession, with activity: NSUserActivity) -> Bool {
    guard ProcessInfo.processInfo.environment["AppStoreScreenshots"] == nil else {
      return false
    }

    switch activity.activityType {
    case SceneDelegate.MainActivityType():
      let storyboard = UIStoryboard(name: .main, bundle: .main)

      guard let answersViewController =
              storyboard.instantiateViewController(withIdentifier: AnswersViewController.identifier) as? AnswersViewController else { return false }

      if let userInfo = activity.userInfo {
        if let rawScreenId = userInfo[SceneDelegate.screenIdKey] as? Int,
           let screenId = Screen.Id(rawValue: rawScreenId) {
          answersViewController.screenId = screenId
          answersViewController.shouldShowAnimation = false
        }

        if let navigationController = window?.rootViewController as? UINavigationController {
          navigationController.pushViewController(answersViewController, animated: false)
        }

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
          appDelegate.skipSplashAnimation = true
        }
      }

      return true
    default:
      return false
    }
  }

  static let MainActivityType = { () -> String in
    let activityTypes = Bundle.main.infoDictionary?["NSUserActivityTypes"] as? [String]
    return activityTypes![0]
  }

  static let screenIdKey = "screenId"
  static let shouldShowSplashKey = "shouldShowSplash"

  func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
    scene.userActivity
  }

  // Utility function to return a Screen instance from the input user activity.
  class func screen(for activity: NSUserActivity) -> Screen? {
    var screen: Screen?

    if let userInfo = activity.userInfo,
       let rawScreenId = userInfo[SceneDelegate.screenIdKey] as? Int,
       let screenId = Screen.Id(rawValue: rawScreenId) {
      screen = ScreenStore.shared.getBy(id: screenId)
    }

    return screen
  }
}

private extension String {
  static let main = "Main"
}
