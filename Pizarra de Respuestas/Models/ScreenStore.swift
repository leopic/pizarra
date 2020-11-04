import Foundation
import UIKit

final class ScreenStore {
  enum Error: Swift.Error {
    case screenNotFound
    case errorLoadingScreen
    case parsing
    case unableToWriteToFile
  }

  public static var shared = ScreenStore()

  private var screens: [Screen] = []
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
    self.fileManager = fileManager
  }

  public func getBy(id: Screen.Id, completion: @escaping (Result<Screen, Error>) -> Void) -> Void {
    guard screens.isEmpty else {
      let result: Result<Screen, Error>

      if let screen = screens.first(where: { $0.id == id }) {
        result = .success(screen)
      } else {
        result = .failure(.screenNotFound)
      }

      completion(result)
      return
    }

    load { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .success(let strategy):
        print("strategy: \(strategy)")
        self.getBy(id: id, completion: completion)
      }
    }
  }

  typealias UpdateCompletion = (Result<Screen, Error>) -> Void
  public func update(_ screen: Screen, completion: UpdateCompletion? = nil) {
    guard let index = screens.firstIndex(where: { screen.id == $0.id }) else {
      completion?(.failure(.screenNotFound))
      return
    }

    screens[index] = screen

    save { result in
      switch result {
      case .success(let strategy):
        print("save.strategy: \(strategy)")

        self.load { result in
          print("load result", result)

          switch result {
          case .success(let strategy):
            if strategy == .fallback {
              completion?(.failure(.unableToWriteToFile))
            } else {
              completion?(.success(screen))
            }
          case .failure(let error):
            completion?(.failure(error))
          }
        }
      case .failure(let error):
        completion?(.failure(error))
      }
    }
  }

  private func delete(completion: (Result<Bool, Error>) -> Void) -> Void {
    if fileManager.fileExists(atPath: self.fileURL.path) {
      print("file exists..")

      do {
        try fileManager.removeItem(atPath: self.fileURL.path)
        completion(.success(true))
        print("delete.okay")
      } catch {
        print("delete.could not remove item", error)
        completion(.failure(.unableToWriteToFile))
      }
    }
  }

  enum SaveStrategy {
    case newFile
    case saveSuccessful
  }
  typealias SaveCompletion = (Result<SaveStrategy, Error>) -> Void
  private func save(completion: SaveCompletion? = nil) -> Void {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }

      guard let data = try? self.encoder.encode(self.screens) else {
        DispatchQueue.main.async {
          completion?(.failure(.parsing))
        }

        return
      }

      guard self.fileManager.fileExists(atPath: self.fileURL.path),
            let fileHandle = try? FileHandle(forWritingTo: self.fileURL) else {
        let result: Result<SaveStrategy, Error>
        do {
          try data.write(to: self.fileURL, options: .atomicWrite)
          result = .success(.newFile)
        } catch {
          result = .failure(.unableToWriteToFile)
        }

        DispatchQueue.main.async {
          completion?(result)
        }

        return
      }

      fileHandle.write(data)
      fileHandle.closeFile()

      DispatchQueue.main.async {
        completion?(.success(.saveSuccessful))
      }
    }
  }

  enum LoadStrategy {
    case firstRun
    case loadSuccessful
    case fixedParsingError
    case fallback
  }
  typealias LoadCompletion = (Result<LoadStrategy, Error>) -> Void
  private func load(completion: @escaping LoadCompletion) -> Void {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }

      guard let data = self.fileManager.contents(atPath: self.fileURL.path) else {
        self.useSeedData()

        DispatchQueue.main.async {
          completion(.success(.firstRun))
        }

        return
      }

      do {
        self.screens = try self.decoder.decode([Screen].self, from: data)

        DispatchQueue.main.async {
          completion(.success(.loadSuccessful))
        }
      } catch {
        if error is Swift.DecodingError,
           let result = String(data: data, encoding: .utf8) {

          if let fixedParsing = result.replacingOccurrences(of: "}]]", with: "}]").data(using: .utf8),
             let results = try? self.decoder.decode([Screen].self, from: fixedParsing) {
            self.screens = results

            DispatchQueue.main.async {
              completion(.success(.fixedParsingError))
            }

            return
          } else {
            print("there was an error that we could not recover from", result)

            self.delete { result in
              print("load.delete", result)

              self.useSeedData()

              DispatchQueue.main.async {
                completion(.success(.fallback))
              }
            }

            return
          }
        } else {
          print("error", error)
          completion(.failure(.errorLoadingScreen))
        }
      }
    }
  }

  private func useSeedData() -> Void {
    print("useSeedData")
    
    screens = [
      ScreenStore.seedScreen(id: .home),
      ScreenStore.seedScreen(id: .binarySelection),
      ScreenStore.seedScreen(id: .moodSelection),
      ScreenStore.seedScreen(id: .positiveMood),
      ScreenStore.seedScreen(id: .negativeMood),
      ScreenStore.seedScreen(id: .painLevel),
      ScreenStore.seedScreen(id: .ambience),
      ScreenStore.seedScreen(id: .sound),
      ScreenStore.seedScreen(id: .temperature),
    ]

    save { result in
      switch result {
      case .success(let strategy):
        print("save.strategy: \(strategy)")
      case .failure(let error):
        print("save.error", error)
      }
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

private extension ScreenStore {
  private class func seedScreen(id: Screen.Id) -> Screen {
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
