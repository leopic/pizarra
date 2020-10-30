import UIKit

//typealias OptionDestination = (screen: Screen.Id, segueId: String)
final class Option: Codable {
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
//  var backgroundColor: UIColor? = nil

  init(
    label: String,
    destination: Destination? = nil,
    backgroundColor: UIColor? = nil,
    tone: Tone = .chime
    ) {
    self.label = label
    self.destination = destination
//    self.backgroundColor = backgroundColor
    self.tone = tone
  }
}
