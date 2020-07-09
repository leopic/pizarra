import UIKit

extension AppDelegate {
  static var isDarkMode: Bool{
    if #available(iOS 12.0, *) {
      return UIScreen.main.traitCollection.userInterfaceStyle == .dark
    } else {
      return false
    }
  }
}
