import Foundation
import UIKit

struct Option: Codable {
  enum Tone: String, Codable {
    case chime = "chime.mp3"
  }

  struct Destination: Codable {
    var screenId: Screen.Id
    var segueId: String
  }

  let label: String
  var tone: Tone
  var destination: Destination?

  private var background: ColorCodable? = nil
  var backgroundColor: UIColor? {
    get {
      background?.uiColor
    }
    set {
      guard let newColor = newValue else { return }
      self.background = ColorCodable(from: newColor)
    }
  }

  init(
    label: String,
    destination: Destination? = nil,
    backgroundColor: UIColor? = nil,
    tone: Tone = .chime
    ) {
    self.label = label
    self.destination = destination
    self.tone = tone
    self.backgroundColor = backgroundColor
  }
}
