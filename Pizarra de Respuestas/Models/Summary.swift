import Foundation

struct Summary {
  var days = [Day]()

  private var base: [String : Int] {
    let mapped = days.flatMap { $0.events.map { $0.value } }.map { ($0, 1) }
    return Dictionary(mapped, uniquingKeysWith: +)
  }

  private var stats: Array<(key: String, value: Int)> {
    base.sorted(by: { $0.value > $1.value })
  }

  public var isEmpty: Bool {
    base.isEmpty
  }

  public func top(_ results: Int = 3) -> [String] {
    stats.prefix(results).map { $0.key }
  }

  public func top(_ results: Int = 3, joinedBy: String) -> String {
    guard !isEmpty else { return "😶" }
    return top(results).joined(separator: joinedBy)
  }

  public var unique: String {
    guard !isEmpty else { return "00" }
    return base.keys.count > 9 ? "\(base.keys.count)" : "0\(base.keys.count)"
  }

  public var totalDays: String {
    guard !isEmpty else { return "00" }
    return days.count > 9 ? "\(days.count)" : "0\(days.count)"
  }
}
