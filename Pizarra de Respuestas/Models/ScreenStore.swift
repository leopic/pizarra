import Foundation

final class ScreenStore {
  enum Error: Swift.Error {
    case screenNotFound
    case unableToWriteToFile
    case unableToDeleteFile
    case encoding
  }

  public static var shared = ScreenStore()

  private var screens: [Screen] = []
  private var fileManager: FileManager
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  init(fileManager: FileManager = FileManager.default) {
    self.fileManager = fileManager
  }

  typealias GetByCompletion = (Result<Screen, Error>) -> Void
  public func getBy(id: Screen.Id, completion: @escaping GetByCompletion) -> Void {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self = self else { return }

      guard self.screens.isEmpty else {
        let result: Result<Screen, Error>

        if let screen = self.screens.first(where: { $0.id == id }) {
          result = .success(screen)
        } else {
          result = .failure(.screenNotFound)
        }

        DispatchQueue.main.async {
          completion(result)
        }

        return
      }

      self.load { result in
        switch result {
        case .failure(let error):
          DispatchQueue.main.async {
            completion(.failure(error))
          }
        case .success(_):
          self.getBy(id: id, completion: completion)
        }
      }
    }
  }

  typealias UpdateCompletion = (Result<Screen, Error>) -> Void
  public func update(_ screen: Screen, completion: UpdateCompletion? = nil) {
    guard let index = screens.firstIndex(where: { screen.id == $0.id }) else {
      completion?(.failure(.screenNotFound))
      return
    }

    guard let data = try? encoder.encode(screen) else {
      completion?(.failure(.encoding))
      return
    }

    let url = urlForScreen(screen.id)

    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self = self else { return }

      self.deleteFileAt(url: url) { result in
        switch result {
        case .failure(let error):
          DispatchQueue.main.async {
            completion?(.failure(error))
          }
        case .success(_):
          let result: Result<Screen, Error>
          do {
            try data.write(to: url, options: .atomicWrite)
            self.screens[index] = screen
            result = .success(screen)
          } catch {
            result = .failure(.unableToWriteToFile)
          }

          DispatchQueue.main.async {
            completion?(result)
          }
        }
      }
    }
  }

  enum DeleteStrategy {
    case fileNotFound
    case success
  }
  private func deleteFileAt(url: URL, completion: (Result<DeleteStrategy, Error>) -> Void) -> Void {
    guard fileManager.fileExists(atPath: url.path) else {
      completion(.success(.fileNotFound))
      return
    }

    let result: Result<DeleteStrategy, Error>
    do {
      try fileManager.removeItem(atPath: url.path)
      result = .success(.success)
    } catch {
      result = .failure(.unableToDeleteFile)
    }

    completion(result)
  }

  enum SaveStrategy {
    case new
    case update
    case either
  }
  typealias SaveCompletion = (Result<SaveStrategy, Error>) -> Void
  private func save(completion: SaveCompletion? = nil) -> Void {
    for screen in screens {
      guard let data = try? self.encoder.encode(screen) else {
        completion?(.failure(.encoding))
        return
      }

      let url = urlForScreen(screen.id)

      if fileManager.fileExists(atPath: url.path),
         let fileHandle = try? FileHandle(forWritingTo: url) {
        fileHandle.write(data)
        fileHandle.closeFile()
      } else {
        do {
          try data.write(to: url, options: .atomicWrite)
        } catch {
          completion?(.failure(.unableToWriteToFile))
          return
        }
      }
    }

    completion?(.success(.either))
  }

  enum LoadStrategy {
    case firstRun
    case loadSuccessful
    case fixedParsingError
    case fallback
  }
  typealias LoadCompletion = (Result<LoadStrategy, Error>) -> Void
  private func load(completion: @escaping LoadCompletion) -> Void {
    var parsedScreens = [Screen]()

    for id in Screen.Id.allCases {
      let url = urlForScreen(id)

      guard let data = self.fileManager.contents(atPath: url.path) else {
        continue
      }

      do {
        parsedScreens.append(try self.decoder.decode(Screen.self, from: data))
      }
      catch {
        continue
      }
    }

    let didParseAllScreens = parsedScreens.count == Screen.Id.allCases.count
    screens = didParseAllScreens ? parsedScreens : seedData()
    completion(.success(didParseAllScreens ? .loadSuccessful : .fallback))
  }

  private func urlForScreen(_ id: Screen.Id) -> URL {
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let baseDirectory = paths[0]
    let fileName = "ScreenStore-\(id).json"
    return baseDirectory.appendingPathComponent(fileName)
  }
}
