import Foundation

struct Event: Codable, CustomStringConvertible {
  var timestamp = Date()
  let value: String

  var description: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    let dateString = formatter.string(from: timestamp)

    return "\(dateString): \(value)"
  }
}
