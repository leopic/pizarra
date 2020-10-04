import Foundation

struct UserPreferences {
  private var storage: UserDefaults = UserDefaults.standard
  private let vibrationEnabledKey = "vibrationEnabled"
  private let soundEnabledKey = "soundEnabled"

  init(storage: UserDefaults = UserDefaults.standard) {
    self.storage = storage
  }

  var isVibrationEnabled: Bool {
    set {
      storage.set(newValue, forKey: vibrationEnabledKey)
    }
    get {
      storage.bool(forKey: vibrationEnabledKey)
    }
  }

  var isSoundEnabled: Bool {
    set {
      storage.set(newValue, forKey: soundEnabledKey)
    }
    get {
      storage.bool(forKey: soundEnabledKey)
    }
  }
}
