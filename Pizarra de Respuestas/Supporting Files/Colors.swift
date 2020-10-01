import UIKit

struct Color {
  static var blackboard: UIColor {
    UIColor(named: "blackboard")!
  }

  static var primary: UIColor {
    UIColor(named: "primary")!
  }

  static var label: UIColor {
    if #available(iOS 13.0, *) {
      return .label
    } else {
      return .black
    }
  }

  static var background: UIColor {
    if #available(iOS 13.0, *) {
      return .systemBackground
    } else {
      return .white
    }
  }
}
