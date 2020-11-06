import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    //    guard let _ = (scene as? UIWindowScene) else { return }

    guard let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity else { return }

    if configure(window: window, session: session, with: userActivity) {
      scene.userActivity = userActivity
      scene.title = userActivity.title

      if let sessionScreen = SceneDelegate.screen(for: userActivity) {
        session.userInfo = [SceneDelegate.screenIdKey: sessionScreen.id.rawValue]
      }
    } else {
      Swift.debugPrint("Failed to restore scene from \(userActivity)")
    }

  }

  func configure(window: UIWindow?, session: UISceneSession, with activity: NSUserActivity) -> Bool {
    var succeeded = false

    // Check the user activity type to know which part of the app to restore.
    if activity.activityType == SceneDelegate.MainActivityType() {
      // The activity type is for restoring DetailParentViewController.

      // Present a parent detail view controller with the specified product and selected tab.
      let storyboard = UIStoryboard(name: "Main", bundle: .main)

      guard let answersViewController =
              storyboard.instantiateViewController(withIdentifier: "AnswersViewController")
              as? AnswersViewController else { return false }

      if let userInfo = activity.userInfo {
        // Decode the user activity product identifier from the userInfo.
        if let rawScreenId = userInfo[SceneDelegate.screenIdKey] as? Int,
           let screenId = Screen.Id(rawValue: rawScreenId) {
          answersViewController.screen = ScreenStore.shared.getBy(id: screenId)
        }

        // Push the detail view controller for the user activity product.
        if let navigationController = window?.rootViewController as? UINavigationController {
          navigationController.pushViewController(answersViewController, animated: false)
        }

        succeeded = true
      }
    } else {
      // The incoming userActivity is not recognizable here.
    }

    return succeeded
  }

  static let MainActivityType = { () -> String in
    // com.leonardopicado.Pizarron.activity.main
    // Load the activity type from the Info.plist.
    let activityTypes = Bundle.main.infoDictionary?["NSUserActivityTypes"] as? [String]
    return activityTypes![0]
  }

  static let screenIdKey = "screenId"

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

