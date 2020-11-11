import Foundation
import UIKit

class SwitchCell: UITableViewCell {
  public static let identifier = "switchCell"

  enum Setting {
    case vibration
    case sound
  }

  @IBOutlet weak var toggle: UISwitch!
  @IBOutlet weak var label: UILabel!

  public var setting: Setting! {
    didSet {
      label.text = isSound ? .soundDisabled : .vibrationDisabled
      label.font = Fonts.headline
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

private extension String {
  static let soundDisabled = NSLocalizedString("screen.settings.sound.disabled", comment: "Sound Disabled label")
  static let vibrationDisabled = NSLocalizedString("screen.settings.vibration.disabled", comment: "Vibration Disabled label")
}
