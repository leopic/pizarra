import Foundation
import UIKit

final class SplashOverlay: UIView {
  typealias Completion = (() -> Void)

  private var logo: UIImageView!
  private var completion: Completion?

  init(completion: Completion? = nil) {
    super.init(frame: UIScreen.main.bounds)

    backgroundColor = Color.blackboard
    logo = UIImageView(image: UIImage(named: .logoVector))
    logo.contentMode = .scaleAspectFit
    logo.translatesAutoresizingMaskIntoConstraints = false
    addSubview(logo!)

    logo.heightAnchor.constraint(equalToConstant: 240).isActive = true
    logo.widthAnchor.constraint(equalToConstant: 240).isActive = true
    logo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    logo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    self.completion = completion

    startAnimation()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func startAnimation() {
    UIView.animate(
      withDuration: 1.2,
      delay: 0.5,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 10,
      options: [.layoutSubviews],
      animations: { [weak self] in
        guard let self = self else { return }
        self.logo.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
      },
      completion: { finished in
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
          guard let self = self else { return }
          self.logo.transform = CGAffineTransform(scaleX: 20.0, y: 20.0)
          self.alpha = 0
          }, completion: { [weak self] finished in
            guard let self = self else { return }
            self.removeFromSuperview()
            self.completion?()
        })
    })
  }
}

private extension String {
  static let logoVector = "logo-vector"
}
