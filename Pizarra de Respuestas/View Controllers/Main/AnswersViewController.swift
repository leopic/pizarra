import Foundation
import UIKit

private enum State {
  case unloaded
  case loading
  case success
  case failed
}

final class AnswersViewController: UIViewController {
  @IBOutlet weak var stackView: UIStackView!

//  public var screenId: Screen.Id?

  public var screen = ScreenStore.shared.getBy(id: .home) {
    didSet {
      state = .success
    }
  }

  private var error: Error? {
    didSet {
      state = .failed
    }
  }

  private var state: State = .unloaded {
    didSet {
      switch state {
      case .success:
        setupNavBar()
        render()
      case .failed:
        print("AnswersVC.failed", String(describing: error))
      default:
        break
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = Color.blackboard
    stackView.distribution = .fillEqually
    stackView.spacing = 16.0
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("viewWillAppear: \(screen.id)")
    loadScreen()
//    render()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if #available(iOS 13.0, *) {
      updateUserActivity()
    } else {
      print("we dont need this...")
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // This view controller is going away, no more user activity to track.
    if #available(iOS 13.0, *) {
//        view.window?.windowScene?.userActivity = nil
    } else {
//        userActivity = nil
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let answersViewController as AnswersViewController:
      guard let option = sender as? Option,
            let screenId = option.destination?.screenId else {
        return
      }

      answersViewController.screen = ScreenStore.shared.getBy(id: screenId)
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

  override func encodeRestorableState(with coder: NSCoder) {
    coder.encode(screen.id.rawValue, forKey: "restoredScreenId")
    super.encodeRestorableState(with: coder)
  }

  override func decodeRestorableState(with coder: NSCoder) {
    let rawScreenId = coder.decodeInteger(forKey: "restoredScreenId")
    if let screenId = Screen.Id(rawValue: rawScreenId) {
      screen = ScreenStore.shared.getBy(id: screenId)
    }

    super.decodeRestorableState(with: coder)
  }

  override func applicationFinishedRestoringState() {
    print("applicationFinishedRestoringState")
//    if let screenId = screenId {
//      loadScreen()
//    } else {
//      self.screenId = .moodSelection
      loadScreen()
//    }
  }

  @available(iOS 13.0, *)
  func updateUserActivity() {
//    guard let screen = screen else { return }

    var currentUserActivity = view.window?.windowScene?.userActivity

    if currentUserActivity == nil {
      currentUserActivity = NSUserActivity(activityType: SceneDelegate.MainActivityType())
    }

    currentUserActivity?.title = screen.title
    currentUserActivity?.targetContentIdentifier = "\(screen.id)"
    currentUserActivity?.addUserInfoEntries(from: [SceneDelegate.screenIdKey: screen.id.rawValue])
    view.window?.windowScene?.userActivity = currentUserActivity
    view.window?.windowScene?.session.userInfo = [SceneDelegate.screenIdKey: screen.id.rawValue]
  }

  private func loadScreen() -> Void {
//    guard let screenId = screenId else { return }

    state = .loading

    ScreenStore.shared.getBy(id: screen.id) { result in
      switch result {
      case .success(let screen):
        self.screen = screen
      case .failure(let error):
        self.error = error
      }
    }
  }

  private func render() -> Void {
    guard isViewLoaded else { return }

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
        Logger.shared.action(option.label)
      }

      return
    }

    performSegue(withIdentifier: destiny.segueId, sender: option)
  }

  private func updateStackViewOrientation() -> Void {
    guard isViewLoaded else { return }

    let device = UIDevice.current
    let iPhoneLandscape = device.userInterfaceIdiom == .phone && device.orientation.isLandscape
    let isiPad = device.userInterfaceIdiom == .pad
    stackView.axis = (iPhoneLandscape || isiPad) ? .horizontal : .vertical
  }

  private func setupNavBar() -> Void {
//    guard let screen = screen else { return }

    title = screen.title

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
