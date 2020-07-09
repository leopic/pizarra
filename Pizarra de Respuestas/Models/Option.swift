import UIKit

typealias OptionDestination = (screen: Screen, segueId: String)
struct Option {
  var label: String
  var destination: OptionDestination?
  var backgroundColor: UIColor?
}
