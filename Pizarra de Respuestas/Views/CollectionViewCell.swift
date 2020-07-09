import UIKit

fileprivate enum CellState {
  case normal
  case selected
}

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet private weak var optionLabel: UILabel!

  fileprivate var state: CellState! {
    didSet {
      refreshView()
    }
  }

  var option: Option! {
    didSet {
      state = .normal
      optionLabel.text = option.label
      contentView.layer.cornerRadius = 6
      contentView.layer.borderWidth = 1.5
      contentView.clipsToBounds = true
      refreshView()
    }
  }

  private func refreshView() {
    let backgroundColor = option.backgroundColor?.withAlphaComponent(0.5) ?? .clear
    contentView.backgroundColor = state == .normal ? backgroundColor : Color.label
    optionLabel.textColor = Color.label
    contentView.layer.borderColor = Color.label.cgColor
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    refreshView()
  }

  func resetCell() {
    state = .normal
  }

  func toggle() {
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()

    UIView.animate(withDuration: 0.4, animations: { [weak self] in
      guard let self = self else { return }
      self.state = self.state == .normal ? .selected : .normal
    })
  }
}
