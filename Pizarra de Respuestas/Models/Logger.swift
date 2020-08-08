import Foundation

final class Logger: TextOutputStream {
  static var track = Logger()
  private static let formatter = DateFormatter()

  private init() {
    Self.formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
  }

  func write(_ string: String) {
    let prefix = "___"
    let date = Self.formatter.string(from: Date())
    print("\(prefix) \(date) \(string)")
  }

  func screen(_ string: String) {
    write("Screen viewed: \(string)")
  }

  func action(_ string: String) {
    write(string)
  }
}
