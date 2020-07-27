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
      refreshView(isInitialRender: true)
    }
  }

  private func refreshView(isInitialRender: Bool = false) {
    clipsToBounds = false
    contentView.backgroundColor = UIColor.clear
    optionLabel.textColor = Color.label

    let reducedFrame = CGRect(
      x: bounds.minX + 10,
      y: bounds.minY + 10,
      width: bounds.width - 20,
      height: bounds.height - 20
    )
    curvedPath = UIBezierPath(roundedRect: reducedFrame, cornerRadius: 12)
    setupRoundShapeLayer()
    setupShadowLayer(isInitialRender: isInitialRender)
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
    state = state == .normal ? .selected : .normal
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
    roundShape.strokeColor = Color.label.withAlphaComponent(0.5).cgColor

    contentView.layer.insertSublayer(roundShape, at: 0)
  }

  private func setupShadowLayer(isInitialRender: Bool = false) -> Void {
    if let sublayers = contentView.layer.sublayers,
      sublayers.contains(shadowLayer) {
      shadowLayer.removeFromSuperlayer()
    }

    shadowLayer = CAShapeLayer()

    let backgroundColor = option.backgroundColor?.withAlphaComponent(0.5) ?? Color.blackboard
    let selectedColor = Color.label.withAlphaComponent(0.5)

    let shadowNormalColor = Color.label.withAlphaComponent(0.25).cgColor
    let shadowSelectedColor = selectedColor.cgColor
    shadowLayer.shadowRadius = 3
    shadowLayer.shadowOpacity = 1.0
    shadowLayer.shadowOffset = CGSize(width: 2, height: 2)

    if !isInitialRender {
      let bgAnimation = CABasicAnimation(keyPath: "fillColor")
      bgAnimation.fromValue = state == .normal ? selectedColor.cgColor : backgroundColor.cgColor
      bgAnimation.toValue = state == .normal ? backgroundColor.cgColor : selectedColor.cgColor
      bgAnimation.duration = 0.4
      shadowLayer.add(bgAnimation, forKey: "fillColor")

      let shadowColorAnimation = CABasicAnimation(keyPath: "shadowColor")
      shadowColorAnimation.fromValue = state == .normal ? shadowSelectedColor : shadowNormalColor
      shadowColorAnimation.toValue = state == .normal ? shadowNormalColor : shadowSelectedColor
      shadowColorAnimation.duration = 0.4
      shadowLayer.add(shadowColorAnimation, forKey: "shadowColor")
    }

    shadowLayer.fillColor = state == .normal ? backgroundColor.cgColor : selectedColor.cgColor
    shadowLayer.shadowColor = state == .normal ? shadowNormalColor : shadowSelectedColor

    shadowLayer.path = curvedPath.cgPath

    contentView.layer.insertSublayer(shadowLayer, below: roundShape)

    contentView.layer.shouldRasterize = true // Cache shadows
    contentView.layer.rasterizationScale = UIScreen.main.scale // Cache them at current scale
  }
}
