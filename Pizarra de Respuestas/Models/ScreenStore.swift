import Foundation
import UIKit

final class ScreenStore {
  enum Error: Swift.Error {
    case screenNotFound
    case errorLoadingScreen
  }

  public static var shared = ScreenStore()

  private var fileManager: FileManager
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  private var fileURL: URL {
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let baseDirectory = paths[0]
    let fileName = "ScreenStore.json"

    return baseDirectory.appendingPathComponent(fileName)
  }

  init(fileManager: FileManager = FileManager.default) {
    print("ScreenStore.init")
    self.fileManager = fileManager
    load()
  }

  public func getBy(id: Screen.Id, completion: (Result<Screen, Error>) -> Void) -> Void {
    print("ScreenStore.getBy: \(store)")
    guard let screen = store.first(where: { $0.id == id }) else {
      return completion(.failure(.screenNotFound))
    }

    completion(.success(screen))
  }

  public func update(_ screen: Screen) {
    print("ScreenStore.update")

    guard let index = store.firstIndex(where: { screen.id == $0.id }) else { return }
    store[index] = screen
    save()
    print("ScreenStore.updated")
  }

  private func save() -> Void {
    print("ScreenStore.save")

    guard let data = try? encoder.encode(store) else {
      print("ScreenStore.ERROR: Unable to turn message: screens into data")
      return
    }

    guard fileManager.fileExists(atPath: fileURL.path),
          let fileHandle = try? FileHandle(forWritingTo: fileURL) else {
      print("ScreenStore.INFO: File does not exist or unable to get a filehandle, trying to create it...")

      do {
        try data.write(to: fileURL, options: .atomicWrite)
        print("ScreenStore.INFO: File created")
      } catch {
        print("ScreenStore.ERROR: Unable to write to file")
      }

      return
    }

    fileHandle.write(data)
    fileHandle.closeFile()
    print("ScreenStore.save completed")
  }

  private func load() -> Void {
    print("ScreenStore.load")

    DispatchQueue.global(qos: .background).async { [weak self] in
      guard let self = self else { return }

      let url = self.fileURL.path

      print("ScreenStore.url", self.fileURL.absoluteString)

      guard let data = self.fileManager.contents(atPath: url),
            let screens = try? self.decoder.decode([Screen].self, from: data) else {
        print("ScreenStore.no previous file")

        self.store = [
            ScreenStore.build(id: .home),
            ScreenStore.build(id: .binarySelection),
            ScreenStore.build(id: .moodSelection),
            ScreenStore.build(id: .positiveMood),
            ScreenStore.build(id: .negativeMood),
            ScreenStore.build(id: .painLevel),
            ScreenStore.build(id: .ambience),
            ScreenStore.build(id: .sound),
            ScreenStore.build(id: .temperature),
          ]

        self.save()

        return
      }

      self.store = screens
      print("ScreenStore.screens loaded", self.store)
    }
  }

  private var store: [Screen] = []

  private class func build(id: Screen.Id) -> Screen {
    switch id {
    case .home:
      let binary = Option(label: .binaryOption, destination: Option.Destination(screenId: .binarySelection, segueId: SegueId.showDetail))
      let mood = Option(label: .moodOption, destination: Option.Destination(screenId: .moodSelection, segueId: SegueId.showDetail))
      let pain = Option(label: .painOption, destination: Option.Destination(screenId: .painLevel, segueId: SegueId.showDetail))
      let ambience = Option(label: .ambienceOption, destination: Option.Destination(screenId: .ambience, segueId: SegueId.showDetail))

      return Screen(title: .home, id: .home, options: [binary, mood, pain, ambience])
    case .binarySelection:
      let positive = Option(label: "👍", backgroundColor: .systemGreen)
      let negative = Option(label: "👎", backgroundColor: .systemRed)

      return Screen(title: .binary, id: .binarySelection, options: [positive, negative])
    case .moodSelection:
      let positiveMood = Option(label: "😀", destination: Option.Destination(screenId: .positiveMood, segueId: SegueId.showDetail), backgroundColor: .systemYellow)
      let negativeMood = Option(label: "🙁", destination: Option.Destination(screenId: .negativeMood, segueId: SegueId.showDetail), backgroundColor: .systemBlue)

      return Screen(title: .mood, id: .moodSelection, options: [positiveMood, negativeMood])
    case .positiveMood:
      let options = ["😀", "✌️", "💪", "❤️"].map { Option(label: $0) }
      return Screen(title: .moodPositive, id: .positiveMood, options: options, canUpdateOptions: true)
    case .negativeMood:
      let options = ["😭", "😩", "😡", "💔"].map { Option(label: $0) }
      return Screen(title: .moodNegative, id: .negativeMood, options: options, canUpdateOptions: true)
    case .painLevel:
      let options = [
        Option(label: "1️⃣😀", backgroundColor: .systemBlue),
        Option(label: "2️⃣🙂", backgroundColor: .systemGreen),
        Option(label: "3️⃣😶", backgroundColor: .systemYellow),
        Option(label: "4️⃣🙁", backgroundColor: .systemOrange),
        Option(label: "5️⃣😭", backgroundColor: .systemRed)
      ]

      return Screen(title: .pain, id: .painLevel, options: options, canUpdateOptions: true)
    case .ambience:
      let sound = Option(label: "🔊", destination: Option.Destination(screenId: .sound, segueId: SegueId.showDetail))
      let temperature = Option(label: "🥵", destination: Option.Destination(screenId: .temperature, segueId: SegueId.showDetail))
      return Screen(title: .ambience, id: .ambience, options: [sound, temperature])
    case .sound:
      let options = ["🔊", "🔇"].map { Option(label: $0) }
      return Screen(title: .sound, id: .sound, options: options)
    case .temperature:
      let options = ["🥵", "👍", "🥶"].map { Option(label: $0) }
      return Screen(title: .temperature, id: .temperature, options: options)
    }
  }
}

private extension String {
  // Options
  static let binaryOption = NSLocalizedString("option.label.binary", comment: "Label for the yes / no option")
  static let moodOption = NSLocalizedString("option.label.mood", comment: "Label for the mood option")
  static let painOption = NSLocalizedString("option.label.pain", comment: "Label for the pain option")
  static let ambienceOption = NSLocalizedString("option.label.ambience", comment: "Label for the ambience option")

  // Screens
  static let create = NSLocalizedString("screen.title.create", comment: "Title for the screen to create a new answer")
  static let edit = NSLocalizedString("screen.title.edit", comment: "Title for the screen to edit an answer")
  static let home = NSLocalizedString("screen.title.home", comment: "Title for the home screen")
  static let ambience = NSLocalizedString("screen.title.ambience", comment: "Title for the ambience screen")
  static let pain = NSLocalizedString("screen.title.pain", comment: "Title for the pain screen")
  static let mood = NSLocalizedString("screen.title.mood", comment: "Title for the mood screen")
  static let moodPositive = NSLocalizedString("screen.title.mood.positive", comment: "Title for the positive mood screen")
  static let moodNegative = NSLocalizedString("screen.title.mood.negative", comment: "Title for the negative mood screen")
  static let binary = NSLocalizedString("screen.title.binary", comment: "Title for the binary question screen")
  static let sound = NSLocalizedString("screen.title.sound", comment: "Title for the sound screen")
  static let temperature = NSLocalizedString("screen.title.temperature", comment: "Title for the temperature screen")
}
