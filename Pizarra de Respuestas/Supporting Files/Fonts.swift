import Foundation
import UIKit

struct Fonts {
  // Additional sizes over at https://gist.github.com/zacwest/916d31da5d03405809c4
  fileprivate enum Size: CGFloat {
    case footnote = 13
    case body = 17
    case title3 = 20
    case title2 = 22
    case title1 = 32
  }

  private static let strongFont = "Noteworthy-Bold"
  private static let normalFont = "Noteworthy-Light"

  static var b: UIFont {
    var font = UIFont(name: strongFont, size: Size.title3.rawValue)!
    font = UIFont.boldSystemFont(ofSize: Size.title3.rawValue)
    let fontMetrics = UIFontMetrics(forTextStyle: .footnote)
    return fontMetrics.scaledFont(for: font)
  }

  static var small: UIFont {
    let font = UIFont(name: normalFont, size: Size.footnote.rawValue)!
    let fontMetrics = UIFontMetrics(forTextStyle: .footnote)
    return fontMetrics.scaledFont(for: font)
  }

  static var p: UIFont {
    let font = UIFont(name: normalFont, size: Size.body.rawValue)!
    let fontMetrics = UIFontMetrics(forTextStyle: .body)
    return fontMetrics.scaledFont(for: font)
  }

  static var h3: UIFont {
    let font = UIFont(name: normalFont, size: Size.title3.rawValue)!
    let fontMetrics = UIFontMetrics(forTextStyle: .title3)
    return fontMetrics.scaledFont(for: font)
  }

  static var h2: UIFont {
    let font = UIFont(name: strongFont, size: Size.title2.rawValue)!
    let fontMetrics = UIFontMetrics(forTextStyle: .title2)
    return fontMetrics.scaledFont(for: font)
  }

  static var h1: UIFont {
    let font = UIFont(name: normalFont, size: Size.title1.rawValue)!
    let fontMetrics = UIFontMetrics(forTextStyle: .title1)
    return fontMetrics.scaledFont(for: font)
  }
}
