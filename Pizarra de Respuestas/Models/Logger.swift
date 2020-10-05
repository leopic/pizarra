import Foundation

final class Logger: TextOutputStream {
  static var track = Logger()

  private var fileManager: FileManager
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  private var fileURL: URL {
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let baseDirectory = paths[0]
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    let dateString = formatter.string(from: Date())
    let fileName = "\(dateString).log"

    return baseDirectory.appendingPathComponent(fileName)
  }

  init(fileManager: FileManager = FileManager.default) {
    self.fileManager = fileManager
    print("Logger.file: \(fileURL.absoluteString)")
  }

  public func write(_ string: String) {
    guard let data = formatMessage(string) else {
      print("Logger.ERROR: Unable to turn message: \(string) into data")
      return
    }

    guard fileManager.fileExists(atPath: fileURL.path),
          let fileHandle = try? FileHandle(forWritingTo: fileURL) else {
      print("LOGGER.ERROR: File does not exist or unable to get a filehandle")

      do {
        try data.write(to: fileURL, options: .atomicWrite)
      } catch {
        print("Logger.ERROR: Unable to write to file")
      }

      return
    }

    fileHandle.seekToEndOfFile()
    fileHandle.write(data)
    fileHandle.closeFile()

    guard let event = try? decoder.decode(Event.self, from: data) else {
      print("LOGER.ERROR: Unable to print current event")
      return
    }

    print("LOGGER.event: \(event.description)")
  }

  public func action(_ string: String) {
    write(string)
  }

  private func formatMessage(_ string: String) -> Data? {
    try? encoder.encode(Event(value: string))
  }
}
