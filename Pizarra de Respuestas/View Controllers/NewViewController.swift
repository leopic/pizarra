import Foundation
import UIKit

final class NewViewController: UIViewController {
  @IBOutlet weak var stackView: UIStackView!

  public var screen = ScreenFactory.build(id: .home)

  override func viewDidLoad() {
    super.viewDidLoad()

    stackView.distribution = .fillEqually
    stackView.spacing = 16.0
    view.backgroundColor = Color.blackboard
    setupNavBar()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    render()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let gridViewController as NewViewController:
      if let option = sender as? Option,
         let screen = option.destination?.screen {
        gridViewController.screen = ScreenFactory.build(id: screen)
      } else {
        print("error transitioning to another screen")
      }
    case let screenDetailViewController as ScreenDetailViewController:
      screenDetailViewController.screen = screen
    default:
      print("no op")
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

    for option in screen.options {
      let button = OptionButton()
      button.option = option
      button.addTarget(self, action: #selector(click), for: .touchUpInside)
      stackView.addArrangedSubview(button)
    }
  }

  @objc private func click(_ sender: UIButton) {
    guard let optionButton = sender as? OptionButton,
          let index = stackView.arrangedSubviews.firstIndex(of: sender) else { return }

    let option = screen.options[index]
    optionButton.toggle()

    guard let destiny = option.destination else {
      if screen.shouldTrackEvents {
        Logger.track.action(option.label)
      }

      return
    }

    performSegue(withIdentifier: destiny.segueId, sender: option)
  }

  private func updateStackViewOrientation() -> Void {
    let device = UIDevice.current

    guard device.orientation.isPortrait else {
      stackView.axis = .horizontal
      return
    }

    stackView.axis = device.userInterfaceIdiom == .pad ? .horizontal : .vertical
  }

  private func setupNavBar() -> Void {
    navigationItem.title = screen.title
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
    guard screen.canUpdateOptions else { return }
    performSegue(withIdentifier: SegueId.showScreenDetail, sender: self)
  }

  @objc private func settingsTapped() -> Void {
    performSegue(withIdentifier: SegueId.showSettings, sender: self)
  }
}
