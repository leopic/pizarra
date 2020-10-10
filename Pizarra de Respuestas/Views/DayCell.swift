import Foundation
import UIKit

final class DayCell: UITableViewCell {
  public var day: Day! {
    didSet {
      textLabel?.text = day.events.map { $0.value }.joined(separator: " ")
      textLabel?.font = Fonts.title2
    }
  }
}
