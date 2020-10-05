import Foundation
import UIKit

enum SettingToggle {
  case vibration
  case sound
}

class SwitchCell: UITableViewCell {
  @IBOutlet weak var toggle: UISwitch!
  @IBOutlet weak var label: UILabel!

  public var setting: SettingToggle! {
    didSet {
      label.text = isSound ? LocalizedStrings.SettingsScreen.soundDisabled : LocalizedStrings.SettingsScreen.vibrationDisabled
      let toggleValue = isSound ? settings.isSoundDisabled : settings.isVibrationDisabled
      toggle.setOn(!toggleValue, animated: false)
      toggle.addTarget(self, action: #selector(tap), for: .valueChanged)
    }
  }

  private var settings = UserPreferences()
  private var isSound: Bool {
    setting == .sound
  }

  @objc private func tap(_ sender: UISwitch) -> Void {
    if isSound {
      settings.isSoundDisabled.toggle()
    } else {
      settings.isVibrationDisabled.toggle()
    }
  }
}

