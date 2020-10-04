import UIKit

class NewViewController: UIViewController {
  @IBOutlet weak var stackView: UIStackView!

  public var screen = ScreenFactory.build(id: .home) {
    didSet {

      stackView.arrangedSubviews.forEach { view in
        view.removeFromSuperview()
      }

      for answer in screen.options {
        let button = UIButton(type: .custom)
        button.titleLabel!.numberOfLines = 0
        button.setTitle(answer.label, for: .normal)
        button.titleLabel!.font = Fonts.h1
        button.titleLabel!.textAlignment = .center
        button.backgroundColor = answer.backgroundColor?.withAlphaComponent(0.50) ?? Color.blackboard
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
        button.layer.borderColor = Color.label.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(click), for: .touchUpInside)

        stackView.addArrangedSubview(button)
      }
    }
  }

  @objc func click(_ sender: UIButton) {
      print("Click", sender)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    stackView.distribution = .fillEqually
    stackView.spacing = 16.0
    navigationItem.title = screen.title
    view.backgroundColor = Color.blackboard
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always

    self.screen = ScreenFactory.build(id: .home)

    guard screen.canUpdateOptions else { return }
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeAnswersTapped))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
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
