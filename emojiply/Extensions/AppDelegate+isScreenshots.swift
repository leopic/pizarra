import Foundation

extension AppDelegate {
  static var isAppStoreScreenshots: Bool {
    ProcessInfo.processInfo.environment["AppStoreScreenshots"] == nil
  }
}
