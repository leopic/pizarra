import Foundation

final class Logger: TextOutputStream {
  static var track = Logger()
  private var fileManager: FileManager

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
    print("logfile: \(fileURL.absoluteString)")
  }

  public func write(_ string: String) {
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

//    let parser = AnalyticsParser()
//    parser.get()
  }

  public func screen(_ string: String) {
    write("Screen viewed: \(string)")
  }

  public func action(_ string: String) {
    write(string)
  }

  private func formatMessage(_ string: String) -> Data? {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    let timestamp = formatter.string(from: Date())

    return "\(timestamp): \(string)\n".data(using: .utf8)
  }
}

struct Event: Codable {
  enum Kind: String, Codable {
    case tap
    case appLaunch
    case screenLoad
  }

  var kind: Kind
  var value: String
  var timestamp = Date()
  var params = [String:String]()
}

public class AnalyticsParser {
  var fileManager = FileManager.default

  @discardableResult public func get() -> String {
    var paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let baseDirectory = paths[0]

    let items = try? fileManager.contentsOfDirectory(atPath: baseDirectory.path)

    for item in items ?? [] {
      print("Found \(item)")
      paths[0].appendPathComponent(item)
      let inner = fileManager.contents(atPath: paths.first!.path)
      print(String(data: inner!, encoding: .utf8))
    }

    return ""
  }
}
