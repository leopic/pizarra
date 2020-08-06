import UIKit
import ColorCompatibility

class OptionFormViewController: UIViewController {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!

  @IBAction func didTapOnSave(_ sender: Any) {
    guard let text = textField.text,
      text != "" else { return }

    let option = Option(label: text, backgroundColor: selectedColor)

    if let index = self.index {
      screen.options[index] = option
    } else {
      screen.options.append(option)
    }

    navigationController?.popViewController(animated: true)
  }

  @IBAction func didTapOnDelete(_ sender: UIButton) {
    let ac = UIAlertController(title: "Confirmar Borrado", message: nil, preferredStyle: .alert)

    ac.addAction(UIAlertAction(title: "Borrar", style: .destructive, handler: {
      [unowned self]  action in
        guard let index = self.index else { return }
        self.screen.options.remove(at: index)
        self.navigationController?.popViewController(animated: true)
    }))

    ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))

    present(ac, animated: true)
  }

  var swatchSize: CGFloat = 64.0
  var screen: Screen!
  var index: Int?
  var selectedColor: UIColor? {
    didSet {
      collectionView.reloadData()
    }
  }

  static let colorList: [UIColor] = [
    .systemBlue,
    .systemGreen,
    ColorCompatibility.systemIndigo,
    .systemOrange,
    .systemPurple,
    .systemRed,
    .systemTeal,
    .systemYellow,
    .clear
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.delegate = self
    collectionView.dataSource = self
    navigationItem.title = index == nil ? "Crear" : "Editar"
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let index = self.index else {
      collectionViewBottomConstraint.isActive = false
      deleteButton.isHidden = true
      return
    }

    let option = screen.options[index]
    textField.text = option.label
    selectedColor = option.backgroundColor
  }
}
