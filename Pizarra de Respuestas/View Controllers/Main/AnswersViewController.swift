import Foundation
import UIKit

final class AnswersViewController: UIViewController {
  @IBOutlet weak var stackView: UIStackView!

  public var screenId: Screen.Id = .home {
    didSet {
      ScreenStore.shared.getBy(id: screenId) { result in
        self.screen = try? result.get()
      }
    }
  }

  private var screen: Screen?

  override func viewDidLoad() {
    super.viewDidLoad()

    stackView.distribution = .fillEqually
    stackView.spacing = 16.0
    view.backgroundColor = Color.blackboard
    updateStackViewOrientation()
    setupNavBar()
    render()

    if screen == nil {
      ScreenStore.shared.getBy(id: screenId) { _ in}
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        ScreenStore.shared.getBy(id: self.screenId) { result in
          self.screen = try? result.get()
          self.setupNavBar()
          self.render()
        }
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    render()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let answersViewController as AnswersViewController:
      guard let option = sender as? Option,
            let screenId = option.destination?.screenId else {
        return
      }

      answersViewController.screenId = screenId
    case let screenDetailViewController as ScreenDetailViewController:
      screenDetailViewController.screen = screen
    default:
      break
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    render()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    updateStackViewOrientation()
  }

  private func render() -> Void {
    updateStackViewOrientation()

    stackView.arrangedSubviews.forEach { view in
      view.removeFromSuperview()
    }

    guard let screen = screen else { return }

    for option in screen.options {
      let button = OptionButton()
      button.option = option
      button.addTarget(self, action: #selector(click), for: .touchUpInside)
      stackView.addArrangedSubview(button)
    }
  }

  @objc private func click(_ sender: UIButton) {
    guard let screen = screen,
          let optionButton = sender as? OptionButton,
          let index = stackView.arrangedSubviews.firstIndex(of: sender) else { return }

    let option = screen.options[index]
    optionButton.toggle()

    guard let destiny = option.destination else {
      if screen.shouldTrackEvents {
        Logger.shared.action(option.label)
      }

      return
    }

    performSegue(withIdentifier: destiny.segueId, sender: option)
  }

  private func updateStackViewOrientation() -> Void {
    let device = UIDevice.current
    let iPhoneLandscape = device.userInterfaceIdiom == .phone && device.orientation.isLandscape
    let isiPad = device.userInterfaceIdiom == .pad
    stackView.axis = (iPhoneLandscape || isiPad) ? .horizontal : .vertical
  }

  private func setupNavBar() -> Void {
    guard let screen = screen else { return }

    title = screen.title
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always

    if screen.id == .home {
      let image = UIImage(named: "gear")
      navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(settingsTapped))
    }

    guard screen.canUpdateOptions else { return }
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeAnswersTapped))
  }

  @objc private func changeAnswersTapped() -> Void {
    guard let screen = screen,
          screen.canUpdateOptions else { return }

    performSegue(withIdentifier: SegueId.showScreenDetail, sender: self)
  }

  @objc private func settingsTapped() -> Void {
    performSegue(withIdentifier: SegueId.showSettings, sender: self)
  }
}
