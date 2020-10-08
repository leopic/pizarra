import Foundation

struct Event: Codable, CustomStringConvertible {
  var timestamp = Date()
  var value: String

  var description: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    let dateString = formatter.string(from: timestamp)

    return "\(dateString): \(value)"
  }
}

final class Day: Codable, CustomStringConvertible, Comparable {
  var events = [Event]()

  var date: Date? {
    events.first?.timestamp
  }

  var last: String? {
    events.last?.value
  }

  var description: String {
    "Date: \(date), total events: \(events.count)"
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
