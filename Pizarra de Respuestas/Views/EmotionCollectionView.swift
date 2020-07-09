import UIKit

enum CellState {
  case normal
  case selected
}

class CollectionViewCell: UICollectionViewCell {
  private let defaultBackgroundColor: UIColor = .white
  private let selectedBackgroundColor: UIColor = .gray

  var state: CellState! {
    didSet {
      contentView.backgroundColor = state == .normal ? selectedBackgroundColor : defaultBackgroundColor
    }
  }

  @IBOutlet weak var emotionLabel: UILabel! {
    didSet {
      state = .normal
      contentView.layer.cornerRadius = 15
      contentView.clipsToBounds = true
      emotionLabel.textColor = .black
    }
  }

  func resetCell() {
    state = .normal
  }

  func toggle() {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()

    UIView.animate(withDuration: 0.4, animations: { [weak self] in
      guard let self = self else { return }
      self.state = self.state == .normal ? .selected : .normal
    })
  }
}
