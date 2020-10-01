import UIKit

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

    guard screen.canUpdateOptions else { return }
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeAnswersTapped))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    Logger.track.screen(screen.title)
    
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.reloadData()
    }
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
        self.collectionView.collectionViewLayout.invalidateLayout()
      })
  }
}
