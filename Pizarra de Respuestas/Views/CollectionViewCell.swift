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
//      contentView.layer.cornerRadius = 6
//      contentView.layer.borderWidth = 1.5
//      contentView.clipsToBounds = true
      refreshView()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    refreshView()
  }

  private func refreshView() {
    clipsToBounds = false
//    let backgroundColor = option.backgroundColor?.withAlphaComponent(0.5) ?? .clear
//    contentView.backgroundColor = state == .normal ? backgroundColor : Color.label
    contentView.backgroundColor = UIColor.clear
//    roundShape.fillColor = state == .normal ? backgroundColor.cgColor : Color.label.cgColor
    optionLabel.textColor = Color.label
//    contentView.layer.borderColor = Color.label.cgColor
//    contentView.layer.borderWidth = 2.0

    let reducedFrame = CGRect(x: bounds.minX+5, y: bounds.minY+5, width: bounds.width-10, height: bounds.height-10)
    curvedPath = UIBezierPath(roundedRect: reducedFrame, cornerRadius: 12)
    setupRoundShapeLayer()
    setupShadowLayer()
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

  private var roundShape = CAShapeLayer()
  private var shadowLayer = CAShapeLayer()
  private var curvedPath: UIBezierPath!

  private func setupRoundShapeLayer() -> Void {
    if let sublayers = contentView.layer.sublayers,
      sublayers.contains(roundShape) {
      roundShape.removeFromSuperlayer()
    }

    roundShape = CAShapeLayer()
    roundShape.path = curvedPath.cgPath
    roundShape.fillColor = UIColor.clear.cgColor


//    roundShape.borderWidth = 2.0
//    roundShape.borderColor = Color.label.cgColor

    contentView.layer.insertSublayer(roundShape, at: 0)
  }

  private func setupShadowLayer() -> Void {
    if let sublayers = contentView.layer.sublayers,
      sublayers.contains(shadowLayer) {
      shadowLayer.removeFromSuperlayer()
    }

    shadowLayer = CAShapeLayer()
    shadowLayer.shadowColor = UIColor.systemGray.cgColor
    shadowLayer.shadowRadius = 2
    shadowLayer.shadowOpacity = 0.5
    shadowLayer.shadowOffset = CGSize(width: 2, height: 2)



        let backgroundColor = option.backgroundColor?.withAlphaComponent(0.5) ?? .clear
    //    contentView.backgroundColor = state == .normal ? backgroundColor : Color.label
    shadowLayer.fillColor = state == .normal ? backgroundColor.cgColor : Color.label.cgColor


    shadowLayer.path = curvedPath.cgPath

    contentView.layer.insertSublayer(shadowLayer, below: roundShape)

    contentView.layer.shouldRasterize = true // Cache shadows
    contentView.layer.rasterizationScale = UIScreen.main.scale // Cache them at current scale
  }
}
