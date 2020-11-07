import Foundation

final class Logger: TextOutputStream {
  static let shared: Logger = {
    var instance = Logger()
    instance.loadToday()
    return instance
  }()

  private var fileManager: FileManager
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private var today: Day!

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
  }

  public func write(_ string: String) {
    guard let data = formatMessage(string) else {
      print("LOGER.ERROR: Unable to turn message: \(string) into data")
      return
    }

    guard fileManager.fileExists(atPath: fileURL.path),
          let fileHandle = try? FileHandle(forWritingTo: fileURL) else {
      print("LOGGER.INFO: File does not exist or unable to get a filehandle, trying to create it...")

      do {
        try data.write(to: fileURL, options: .atomicWrite)
        print("LOGGER.INFO: File created")
      } catch {
        print("LOGER.ERROR: Unable to write to file")
      }

      return
    }

    fileHandle.write(data)
    fileHandle.closeFile()

    if let lastEvent = today.last {
      print("LOGGER.saved: \(lastEvent)")
    }
  }

  private func loadToday() -> Void {
    DispatchQueue.global(qos: .background).async { [weak self] in
      guard let self = self else { return }

      let url = self.fileURL.path

      guard let data = self.fileManager.contents(atPath: url),
            let day = try? self.decoder.decode(Day.self, from: data) else {
        self.today = Day()
        return
      }

      self.today = day
    }
  }

  public func action(_ string: String) {
    DispatchQueue.global(qos: .background).async { [weak self] in
      self?.write(string)
    }
  }

  public func getAll() -> [Day] {
    var days = [Day]()
    let decoder = JSONDecoder()
    let fileManager = FileManager.default
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)

    guard let baseDirectory = paths.first else {
      print("LogRetriever: unable to get first path")
      return days
    }

    guard let items = try? fileManager.contentsOfDirectory(atPath: baseDirectory.path) else {
      print("LogRetriever: unable to get contents of directory")
      return days
    }

    for item in items where item != "ScreenStore.log" {
      print("LogRetriever: iterating over \(item)")

      guard let data = fileManager.contents(atPath: baseDirectory.appendingPathComponent(item).path) else {
        print("LogRetriever: unable to turn contents of the path into data")
        continue
      }

      do {
        days.append(try decoder.decode(Day.self, from: data))
      } catch {
        print("LogRetriever.unable to parse day: \(error)")
      }
    }

    return days.sorted().reversed()
  }

  private func formatMessage(_ string: String) -> Data? {
    do {
      today.events.append(Event(value: string))
      return try encoder.encode(today)
    } catch {
      print("LOGER.ERROR: this blew up!", error)
      return nil
    }
  }
}
