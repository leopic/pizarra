import UIKit

typealias OptionDestination = (screen: Screen.Id, segueId: String)
class Option {
  var label: String!
  var destination: OptionDestination?
  var backgroundColor: UIColor?

  init(label: String, destination: OptionDestination? = nil, backgroundColor: UIColor? = nil) {
    self.label = label
    self.destination = destination
    self.backgroundColor = backgroundColor
  }
}
