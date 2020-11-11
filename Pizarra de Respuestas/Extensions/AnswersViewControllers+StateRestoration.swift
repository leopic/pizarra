import Foundation
import UIKit

extension AnswersViewController {
  override func encodeRestorableState(with coder: NSCoder) {
    coder.encode(screen.id.rawValue, forKey: "restoredScreenId")
    super.encodeRestorableState(with: coder)
  }

  override func decodeRestorableState(with coder: NSCoder) {
    shouldShowAnimation = false
    let rawScreenId = coder.decodeInteger(forKey: "restoredScreenId")
    if let screenId = Screen.Id(rawValue: rawScreenId) {
      screen = ScreenStore.shared.getBy(id: screenId)
    }

    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      appDelegate.skipSplashAnimation = true
    }

    super.decodeRestorableState(with: coder)
  }

  override func applicationFinishedRestoringState() {
    loadScreen()
  }

  @available(iOS 13.0, *)
  func updateUserActivity() {
    var currentUserActivity = view.window?.windowScene?.userActivity

    if currentUserActivity == nil {
      currentUserActivity = NSUserActivity(activityType: SceneDelegate.MainActivityType())
    }

    currentUserActivity?.title = screen.title
    currentUserActivity?.targetContentIdentifier = "\(screen.id)"
    currentUserActivity?.addUserInfoEntries(from: [
      SceneDelegate.screenIdKey: screen.id.rawValue,
      SceneDelegate.shouldShowSplashKey: false
    ])

    view.window?.windowScene?.userActivity = currentUserActivity
    view.window?.windowScene?.session.userInfo = [
      SceneDelegate.screenIdKey: screen.id.rawValue,
      SceneDelegate.shouldShowSplashKey: false
    ]
  }
}
