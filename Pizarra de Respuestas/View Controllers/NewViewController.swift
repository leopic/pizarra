import Foundation
import UIKit

final class NewViewController: UIViewController {
  @IBOutlet weak var stackView: UIStackView!

  public var screen = ScreenFactory.build(id: .home)

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    render()
  }

  private func render() -> Void {
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
        Logger.track.action("Tapped on option: \(option.label ?? "N/A")")
      }

      return
    }

    performSegue(withIdentifier: destiny.segueId, sender: option)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    stackView.distribution = .fillEqually
    stackView.spacing = 16.0
    stackView.axis = .horizontal
    navigationItem.title = screen.title
    view.backgroundColor = Color.blackboard
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always

    guard screen.canUpdateOptions else { return }
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeAnswersTapped))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard screen.shouldTrackEvents else { return }
    Logger.track.screen(screen.title)
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

  @objc private func changeAnswersTapped() {
    guard screen.canUpdateOptions else { return }
    performSegue(withIdentifier: SegueId.showScreenDetail, sender: self)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    render()
  }
}
