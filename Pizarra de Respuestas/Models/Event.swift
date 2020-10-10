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

struct Summary {
  var days = [Day]()
  public var stats: Array<(key: String, value: Int)> {
    let mapped = days.flatMap { $0.events.map { $0.value } }.map { ($0, 1) }
    let counts = Dictionary(mapped, uniquingKeysWith: +)
    return counts.sorted(by: { $0.value > $1.value })
  }
  public func top(_ results: Int = 5) -> [String] {
    stats.prefix(results).map { $0.key }
  }
  public var unique: Int {
    let mapped = days.flatMap { $0.events.map { $0.value } }.map { ($0, 1) }
    let counts = Dictionary(mapped, uniquingKeysWith: +)
    return counts.keys.count
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
