import UIKit

class GridViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!

  var screen = ScreenFactory.build(id: .home)!
//  var answers: [String]!

  let itemsPerRow: CGFloat = 2
  let itemsPerColumn: CGFloat = 2
  static let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

  private var defaultAnswers: [String]!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.navigationBar.barTintColor = Color.blackboard
    view.backgroundColor = Color.blackboard
    collectionView.backgroundColor = .clear

    collectionView.dataSource = self
    collectionView.delegate = self

    navigationItem.title = screen.title
//    answers = screen.options.compactMap { $0.label }
//    defaultAnswers = screen.options.compactMap { $0.label }

    if screen.canUpdateOptions {
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cambiar", style: .plain, target: self, action: #selector(changeAnswersTapped))
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("viewDidAppear.options.count", screen.options.count)
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
    guard screen.canUpdateOptions else {
      return
    }

    performSegue(withIdentifier: "showScreenDetail", sender: self)

//    let alert = UIAlertController(title: "Cambiar Respuestas", message: nil, preferredStyle: .alert)
//
//    for index in screen.options.indices {
//      alert.addTextField { [weak self] (textField) in
//        guard let self = self else { return }
//        textField.text = self.answers[index, default: self.defaultAnswers[index]]
//      }
//    }
//
//    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
//
//    alert.addAction(UIAlertAction(title: "Cambiar", style: .default) { [weak alert] action in
//      guard let alert = alert,
//            let textfields = alert.textFields,
//            let cells = self.collectionView.visibleCells as? [CollectionViewCell] else { return }
//
//      cells.forEach { $0.resetCell() }
//      self.answers = textfields.filter { $0.text != "" }.compactMap { $0.text }
//      self.collectionView.reloadData()
//    })
//
//    present(alert, animated: true, completion: nil)
  }
}
