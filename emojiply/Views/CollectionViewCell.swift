import UIKit

fileprivate enum State {
  case normal
  case selected
}

fileprivate enum RenderReason {
  case initial
  case user
  case os
}

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet private weak var optionLabel: UILabel!

  var option: Option! {
    didSet {
      state = .normal
      renderReason = .initial
      optionLabel.text = option.label
      refreshView()
    }
  }

  private var roundShape = CAShapeLayer()
  private var shadowLayer = CAShapeLayer()
  private var curvedPath: UIBezierPath!
  private var borderColor: CGColor {
    Color.label.withAlphaComponent(0.5).cgColor
  }

  private var shadowColor: CGColor {
    Color.label.withAlphaComponent(0.125).cgColor
  }

  private var renderReason: RenderReason!
  private var state: State! {
    didSet {
      refreshView()
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    renderReason = .os
    refreshView()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    renderReason = .os
    refreshView()
  }

  func resetCell() {
    renderReason = .initial
    state = .normal
  }

  func toggle() {
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    renderReason = .user
    state = state == .normal ? .selected : .normal
  }

  private func refreshView() {
    clipsToBounds = false
    contentView.backgroundColor = UIColor.clear
    optionLabel.textColor = Color.label
    optionLabel.font = UIFont.preferredFont(forTextStyle: .title1)

    let reducedFrame = CGRect(
      x: bounds.minX + 4,
      y: bounds.minY + 4,
      width: bounds.width - 12,
      height: bounds.height - 12
    )

    curvedPath = UIBezierPath(roundedRect: reducedFrame, cornerRadius: 12)
    setupRoundShapeLayer()
    setupShadowLayer()
  }

  private func setupRoundShapeLayer() -> Void {
    if let sublayers = contentView.layer.sublayers,
      sublayers.contains(roundShape) {
      roundShape.removeFromSuperlayer()
    }

    roundShape = CAShapeLayer()
    roundShape.path = curvedPath.cgPath
    roundShape.fillColor = UIColor.clear.cgColor
    roundShape.strokeColor = borderColor

    contentView.layer.insertSublayer(roundShape, at: 0)
  }

  private func setupShadowLayer() -> Void {
    if let sublayers = contentView.layer.sublayers,
      sublayers.contains(shadowLayer) {
      shadowLayer.removeFromSuperlayer()
    }

    shadowLayer = CAShapeLayer()

    let normalBackgroundColor = (option.backgroundColor?.withAlphaComponent(0.5) ?? Color.blackboard).cgColor
    let selectedBackgroundColor = borderColor

    let normalShadowColor = shadowColor
    let selectedShadowColor = selectedBackgroundColor
    shadowLayer.shadowRadius = 3
    shadowLayer.shadowOpacity = 1.0
    shadowLayer.shadowOffset = CGSize(width: 2, height: 2)

    let animationDuration: CFTimeInterval = 0.4
    if renderReason == .user {
      let bgAnimation = CABasicAnimation(keyPath: "fillColor")
      bgAnimation.fromValue = state == .normal ? selectedBackgroundColor : normalBackgroundColor
      bgAnimation.toValue = state == .normal ? normalBackgroundColor : selectedBackgroundColor
      bgAnimation.duration = animationDuration
      shadowLayer.add(bgAnimation, forKey: "fillColor")

      let shadowColorAnimation = CABasicAnimation(keyPath: "shadowColor")
      shadowColorAnimation.fromValue = state == .normal ? selectedShadowColor : normalShadowColor
      shadowColorAnimation.toValue = state == .normal ? normalShadowColor : selectedShadowColor
      shadowColorAnimation.duration = animationDuration
      shadowLayer.add(shadowColorAnimation, forKey: "shadowColor")
    }

    shadowLayer.fillColor = state == .normal ? normalBackgroundColor : selectedBackgroundColor
    shadowLayer.shadowColor = state == .normal ? normalShadowColor : selectedShadowColor

    shadowLayer.path = curvedPath.cgPath

    contentView.layer.insertSublayer(shadowLayer, below: roundShape)

    contentView.layer.shouldRasterize = true // Cache shadows
    contentView.layer.rasterizationScale = UIScreen.main.scale // Cache them at current scale
  }
}
