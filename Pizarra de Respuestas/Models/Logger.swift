import Foundation

final class Logger: TextOutputStream {
  static var track = Logger()
  var fileManager = FileManager.default

  private var fileURL: URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let baseDirectory = paths[0]
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    let dateString = formatter.string(from: Date())
    let fileName = "\(dateString).log"

    return baseDirectory.appendingPathComponent(fileName)
  }

  private init() {
    print("logfile: \(fileURL.absoluteString)")
  }

  func write(_ string: String) {
    guard let messageAsData = formatMessage(string) else {
      print("Logger.ERROR: Unable to turn message: \(string) into data")
      return
    }

    guard fileManager.fileExists(atPath: fileURL.path),
        let fileHandle = try? FileHandle(forWritingTo: fileURL) else {
      print("Logger.ERROR: File does not exist or unable to get a filehandle")

      do {
        try messageAsData.write(to: fileURL, options: .atomicWrite)
      } catch {
        print("Logger.ERROR: Unable to write to file")
      }

      return
    }

    fileHandle.seekToEndOfFile()
    fileHandle.write(messageAsData)
    fileHandle.closeFile()

    print(string)
  }

  func screen(_ string: String) {
    write("Screen viewed: \(string)")
  }

  func action(_ string: String) {
    write(string)
  }

  private func formatMessage(_ string: String) -> Data? {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    let timestamp = formatter.string(from: Date())

    return "\(timestamp): \(string)\n".data(using: .utf8)
  }
}
