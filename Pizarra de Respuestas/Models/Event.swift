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
