import Foundation
import UIKit

// UIColor does not conform to Codable, manually conformance is needed
// https://stackoverflow.com/questions/50928153/make-uicolor-codable
struct ColorCodable: Codable {
  var red: CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  var alpha: CGFloat = 1.0

  var uiColor: UIColor {
    UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

  init(from: UIColor) {
    from.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
  }
}
