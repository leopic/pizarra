import UIKit

typealias OptionDestination = (screen: Screen.Id, segueId: String)
final class Option {
  enum Tone: String {
    case chime = "chime.mp3"
  }

  let label: String
  var tone: Tone
  var destination: OptionDestination?
  var backgroundColor: UIColor?

  init(
    label: String,
    destination: OptionDestination? = nil,
    backgroundColor: UIColor? = nil,
    tone: Tone = .chime
    ) {
    self.label = label
    self.destination = destination
    self.backgroundColor = backgroundColor
    self.tone = tone
  }
}
