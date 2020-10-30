import Foundation
import AVFoundation
import UIKit

class OptionButton: UIButton {
  var soundEffect: AVAudioPlayer?

  public var option: Option! {
    didSet {
      setTitle(option.label, for: .normal)
      titleLabel?.numberOfLines = 0
      titleLabel?.font = Fonts.largeTitle
      titleLabel?.textAlignment = .center
//      backgroundColor = option.backgroundColor?.withAlphaComponent(0.50) ?? Color.blackboard
      backgroundColor = Color.blackboard

      clipsToBounds = true
      heightAnchor.constraint(equalTo: widthAnchor).isActive = true
      layer.cornerRadius = 8
      layer.borderColor = Color.label.withAlphaComponent(0.5).cgColor
//      layer.borderColor = option.backgroundColor?.withAlphaComponent(0.50).cgColor ?? Color.label.withAlphaComponent(0.5).cgColor
      layer.borderWidth = 1.5
    }
  }

  public func toggle() {
    isSelected.toggle()

    UIView.animate(withDuration: 0.25) { [weak self] in
      guard let self = self else { return }
//      let normal = self.option.backgroundColor?.withAlphaComponent(0.50) ?? Color.blackboard
      let normal = Color.blackboard
      let selected = Color.label.withAlphaComponent(0.50)
      self.backgroundColor = self.isSelected ? selected : normal
    }

    guard option.destination == nil,
          isSelected else {
      return
    }

    let userSettings = UserPreferences()

    if !userSettings.isVibrationDisabled {
      UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    if !userSettings.isSoundDisabled {
      let path = Bundle.main.path(for: option.tone)
      let url = URL(fileURLWithPath: path)
      try? AVAudioSession.sharedInstance().setCategory(.playback)
      soundEffect = try? AVAudioPlayer(contentsOf: url)
      soundEffect?.play()
    }
  }
}

private extension Bundle {
  func path(for tone: Option.Tone) -> String {
    return path(forResource: tone.rawValue, ofType: nil)!
  }
}
