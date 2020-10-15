import Foundation

struct Day: Codable, CustomStringConvertible, Comparable {
  var events = [Event]()

  var date: Date? {
    events.first?.timestamp
  }

  var last: String? {
    events.last?.value
  }

  var description: String {
    "Date: \(String(describing: date)), total events: \(events.count)"
  }

  static func <(lhs: Day, rhs: Day) -> Bool {
    guard let lDate = lhs.date,
          let rDate = rhs.date else {
      return false
    }

    return lDate < rDate
  }

  static func == (lhs: Day, rhs: Day) -> Bool {
    lhs.date == rhs.date
  }
}
