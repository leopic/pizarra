import UIKit

class GridViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!

  var screen = ScreenFactory.build(id: .home)!

  let itemsPerRow: CGFloat = 2
  let itemsPerColumn: CGFloat = 2
  static let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.navigationBar.barTintColor = Color.blackboard
    view.backgroundColor = Color.blackboard
    collectionView.backgroundColor = .clear

    collectionView.dataSource = self
    collectionView.delegate = self

    navigationItem.title = screen.title

    guard screen.canUpdateOptions else { return }
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cambiar", style: .plain, target: self, action: #selector(changeAnswersTapped))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.reloadData()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? GridViewController,
          let option = sender as? Option,
          let screen = option.destination?.screen {
      destination.screen = ScreenFactory.build(id: screen)!
    }

    if let destination = segue.destination as? ScreenDetailViewController {
      destination.screen = screen
    }
  }

  @objc private func changeAnswersTapped() {
    guard screen.canUpdateOptions else { return }
    performSegue(withIdentifier: "showScreenDetail", sender: self)
  }
}
