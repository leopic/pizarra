import Foundation
import UIKit

class OptionButton: UIButton {
  public var option: Option! {
    didSet {
      setTitle(option.label, for: .normal)
      titleLabel?.numberOfLines = 0
      titleLabel?.font = Fonts.h1
      titleLabel?.textAlignment = .center
      backgroundColor = option.backgroundColor?.withAlphaComponent(0.50) ?? Color.blackboard
      clipsToBounds = true
      heightAnchor.constraint(equalTo: widthAnchor).isActive = true
      layer.cornerRadius = 6
      layer.borderColor = Color.label.withAlphaComponent(0.5).cgColor
      layer.borderWidth = 2.0
    }
  }

  public func toggle() {
    isSelected.toggle()

    UIImpactFeedbackGenerator(style: .medium).impactOccurred()

    let normal = option.backgroundColor?.withAlphaComponent(0.50) ?? Color.blackboard
    let selected = Color.label.withAlphaComponent(0.5)
    UIView.animate(withDuration: 0.25) {
      self.backgroundColor = self.isSelected ? selected : normal
    }
  }
}
