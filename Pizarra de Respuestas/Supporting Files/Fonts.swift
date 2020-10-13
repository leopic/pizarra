import Foundation
import UIKit

struct Fonts {
  // Additional sizes over at https://gist.github.com/zacwest/916d31da5d03405809c4
  enum Size: CGFloat {
    case largeTitle = 34
    case title1 = 28
    case title2 = 22
    case title3 = 20
    case headline = 17 // body
    case callout = 16
    case subheadline = 15
    case footnote = 13
    case caption1 = 12
    case caption2 = 11
  }

  private static let strongFont = "AvenirNextCondensed-Bold"
  private static let normalFont = "AvenirNextCondensed-Medium"

  static var largeTitle: UIFont {
    let font = UIFont(name: strongFont, size: .largeTitle)
    let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
    return fontMetrics.scaledFont(for: font)
  }

  static var title1: UIFont {
    let font = UIFont(name: strongFont, size: .title1)
    let fontMetrics = UIFontMetrics(forTextStyle: .title1)
    return fontMetrics.scaledFont(for: font)
  }

  static var title2: UIFont {
    let font = UIFont(name: normalFont, size: .title1)
    let fontMetrics = UIFontMetrics(forTextStyle: .title1)
    return fontMetrics.scaledFont(for: font)
  }

  static var title3: UIFont {
    let font = UIFont(name: normalFont, size: .title3)
    let fontMetrics = UIFontMetrics(forTextStyle: .title3)
    return fontMetrics.scaledFont(for: font)
  }

  static var headline: UIFont {
    let font = UIFont(name: normalFont, size: .headline)
    let fontMetrics = UIFontMetrics(forTextStyle: .headline)
    return fontMetrics.scaledFont(for: font)
  }
}

private extension UIFont {
  convenience init(name fontName: String, size fontSize: Fonts.Size) {
    self.init(name: fontName, size: fontSize.rawValue)!
  }
}
