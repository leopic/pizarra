import UIKit

class OptionButton: UIButton {
  public var option: Option! {
    didSet {
      setTitle(option.label, for: .normal)
      titleLabel?.numberOfLines = 0
      titleLabel?.font = Fonts.h1
      titleLabel?.textAlignment = .center
      backgroundColor = option.backgroundColor?.withAlphaComponent(0.50) ?? Color.blackboard
      clipsToBounds = true
      heightAnchor.constraint(equalTo: widthAnchor).isActive = true
      layer.cornerRadius = 6
      layer.borderColor = Color.label.withAlphaComponent(0.5).cgColor
      layer.borderWidth = 2.0
    }
  }

  public func toggle() {
    isSelected.toggle()

    UIImpactFeedbackGenerator(style: .medium).impactOccurred()

    let normal = option.backgroundColor?.withAlphaComponent(0.50) ?? Color.blackboard
    let selected = Color.label.withAlphaComponent(0.5)
    UIView.animate(withDuration: 0.25) {
      self.backgroundColor = self.isSelected ? selected : normal
    }
  }
}

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

class GridViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!

  static let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
  public var screen = ScreenFactory.build(id: .home)

  let itemsPerRow: CGFloat = 2
  let itemsPerColumn: CGFloat = 2

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = screen.title
    view.backgroundColor = Color.blackboard
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self

    collectionView.contentInset.top = max((collectionView.frame.height - collectionView.contentSize.height) / 2, 0)

    guard screen.canUpdateOptions else { return }
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeAnswersTapped))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    collectionView.contentInset.top = max((collectionView.frame.height - collectionView.contentSize.height) / 2, 0)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    DispatchQueue.main.async { [weak self] in
      self!.collectionView.contentInset.top = max((self!.collectionView.frame.height - self!.collectionView.contentSize.height) / 2, 0)
      self?.collectionView.reloadData()
    }

    guard screen.id != .binarySelection else { return }
    Logger.track.screen(screen.title)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let gridViewController as GridViewController:
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

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    
    coordinator.animate(
      alongsideTransition: { context in
        self.collectionView.contentInset.top = max((self.collectionView.frame.height - self.collectionView.contentSize.height) / 2, 0)
        self.collectionView.collectionViewLayout.invalidateLayout()
      })
  }
}
