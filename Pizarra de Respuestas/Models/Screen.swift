import Foundation

class Screen {
  enum Id {
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

  var title: String
  var options: [Option]
  var canUpdateOptions: Bool
  var id: Id

  init(title: String, id: Id, options: [Option], canUpdateOptions: Bool = false) {
    self.title = title
    self.id = id
    self.options = options
    self.canUpdateOptions = canUpdateOptions
  }
}
