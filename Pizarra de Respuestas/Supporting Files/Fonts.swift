import Foundation
import UIKit

struct Fonts {
  // Additional sizes over at https://gist.github.com/zacwest/916d31da5d03405809c4
  fileprivate enum Size: CGFloat {
    case title2 = 20
    case title1 = 34
  }

  private static let strongFont = "AvenirNextCondensed-Bold"
  private static let normalFont = "AvenirNextCondensed-Medium"

  static var h1: UIFont {
    let font = UIFont(name: normalFont, size: Size.title1.rawValue)!
    let fontMetrics = UIFontMetrics(forTextStyle: .title1)
    return fontMetrics.scaledFont(for: font)
  }

  static var h2: UIFont {
    let font = UIFont(name: strongFont, size: Size.title2.rawValue)!
    let fontMetrics = UIFontMetrics(forTextStyle: .title2)
    return fontMetrics.scaledFont(for: font)
  }

  static var h3: UIFont {
    let font = UIFont(name: normalFont, size: Size.title2.rawValue)!
    let fontMetrics = UIFontMetrics(forTextStyle: .title2)
    return fontMetrics.scaledFont(for: font)
  }
}
