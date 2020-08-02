import UIKit

class Screen {
  enum Id {
    case home
    case binarySelection
    case moodSelection
    case positiveMood
    case negativeMood
    case status
    case ambience
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
