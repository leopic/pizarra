import Foundation

struct UserPreferences {
  private var storage: UserDefaults = UserDefaults.standard
  private let vibrationDisabledKey = "vibrationDisabled"
  private let soundDisabled = "soundDisabled"

  init(storage: UserDefaults = UserDefaults.standard) {
    self.storage = storage
  }

  var isVibrationDisabled: Bool {
    set {
      storage.set(newValue, forKey: vibrationDisabledKey)
    }
    get {
      storage.bool(forKey: vibrationDisabledKey)
    }
  }

  var isSoundDisabled: Bool {
    set {
      storage.set(newValue, forKey: soundDisabled)
    }
    get {
      storage.bool(forKey: soundDisabled)
    }
  }
}
