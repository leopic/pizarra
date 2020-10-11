import Foundation
import UIKit

enum Fontarello {
  case largeTitle

  var name: String {
    let base = "AvenirNextCondensed"

    switch self {
    case .largeTitle:
      return "\(base)-Bold"
    }
  }

  var size: CGFloat {
    switch self {
    case .largeTitle:
      return 34
    }
  }

  var style: UIFont.TextStyle {
    switch self {
    case .largeTitle:
      return .largeTitle
    }
  }
}

struct Fonts {
  // Additional sizes over at https://gist.github.com/zacwest/916d31da5d03405809c4
  enum Size: CGFloat {
    case largeTitle = 34
    case title1 = 28
    case title2 = 22
    case title3 = 20
    case headline = 17
    case callout = 16
    case subheadline = 15
//    case body = 17 - fak
    case footnote = 13
    case caption1 = 12
    case caption2 = 11
  }

  private static let strongFont = "AvenirNextCondensed-Bold"
  private static let normalFont = "AvenirNextCondensed-Medium"

  static var largeTitle: UIFont {
    let fontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
    let font = UIFont(fontarello: .largeTitle)!
    return fontMetrics.scaledFont(for: font)
  }

  static var title1: UIFont {
    let font = UIFont(name: strongFont, size: .title1)!
    let fontMetrics = UIFontMetrics(forTextStyle: .title1)
    return fontMetrics.scaledFont(for: font)
  }

  static var title2: UIFont {
    let font = UIFont(name: normalFont, size: .title1)!
    let fontMetrics = UIFontMetrics(forTextStyle: .title1)
    return fontMetrics.scaledFont(for: font)
  }

  static var title3: UIFont {
    let font = UIFont(name: normalFont, size: .title3)!
    let fontMetrics = UIFontMetrics(forTextStyle: .title3)
    return fontMetrics.scaledFont(for: font)
  }
}

extension UIFont {
  convenience init?(name fontName: String, size fontSize: Fonts.Size) {
    self.init(name: fontName, size: fontSize.rawValue)
  }

  convenience init?(fontarello: Fontarello) {
    self.init(name: fontarello.name, size: fontarello.size)
  }
}
