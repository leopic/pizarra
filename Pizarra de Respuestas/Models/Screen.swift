import Foundation

final class Screen: Codable {
  enum Id: Int, Codable {
    case home
    case binarySelection
    case moodSelection
    case positiveMood
    case negativeMood
    case painLevel
    case ambience
    case sound
    case temperature
  }

  let title: String
  let canUpdateOptions: Bool
  let id: Id
  let shouldTrackEvents: Bool
  var options: [Option]

  init(
    title: String,
    id: Id,
    options: [Option],
    canUpdateOptions: Bool = false,
    shouldTrackEvents: Bool = true
  ) {
    self.title = title
    self.id = id
    self.options = options
    self.canUpdateOptions = canUpdateOptions
    self.shouldTrackEvents = shouldTrackEvents
  }
}
