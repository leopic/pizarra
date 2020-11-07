import UIKit
import ColorCompatibility

class EditOptionViewController: UIViewController {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!

  @IBAction func didTapOnSave(_ sender: Any) {
    guard let text = textField.text,
          text != "" else {
      let ac = UIAlertController(title: .error, message: .emptyOption, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: .ok, style: .default))
      present(ac, animated: true)
      return
    }

    guard text.count < 4 else {
      let ac = UIAlertController(title: .error, message: .longOption, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: .ok, style: .default))
      present(ac, animated: true)
      return
    }

    let option = Option(label: text, backgroundColor: selectedColor)

    if let index = index {
      screen.options[index] = option
    } else {
      screen.options.append(option)
    }

    save()
  }

  @IBAction func didTapOnDelete(_ sender: UIButton) {
    let ac = UIAlertController(title: .confirmDeletion, message: nil, preferredStyle: .alert)

    ac.addAction(UIAlertAction(title: .delete, style: .destructive, handler: {
      [unowned self]  action in
      guard let index = self.index else { return }
      self.screen.options.remove(at: index)
      self.save()
    }))

    ac.addAction(UIAlertAction(title: .cancel, style: .cancel))

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
    .systemYellow
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.delegate = self
    collectionView.dataSource = self
    title = index == nil ? .create : .edit
    textField.borderStyle = .none
    textField.layer.cornerRadius = 8.0
    collectionView.layer.cornerRadius = 8.0
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    collectionView.backgroundColor = Color.background
    textField.backgroundColor = Color.background
    view.backgroundColor = Color.blackboard
    
    guard let index = self.index else {
      collectionViewBottomConstraint.isActive = false
      deleteButton.isHidden = true
      return
    }

    let option = screen.options[index]
    textField.text = option.label
    selectedColor = option.backgroundColor
  }

  private func save() -> Void {
    ScreenStore.shared.update(screen) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success(_):
        self.navigationController?.popViewController(animated: true)
      case .failure(let error):
        print("OptionFormVC.save.error!", error)
      }
    }
  }
}

private extension String {
  static let create = NSLocalizedString("screen.title.create", comment: "Title for the screen to create a new answer")
  static let edit = NSLocalizedString("screen.title.edit", comment: "Title for the screen to edit an answer")
  static let error = NSLocalizedString("alert.title.error", comment: "Title for error messages")
  static let confirmDeletion = NSLocalizedString("alert.title.confirm-deletion", comment: "Title confirming the deletion of an option")
  static let ok = NSLocalizedString("general.button.okay", comment: "Accept presented information")
  static let delete = NSLocalizedString("general.button.delete", comment: "Delete the selected item")
  static let cancel = NSLocalizedString("general.button.cancel", comment: "Avoid the current action from being executed")
  static let emptyOption = NSLocalizedString("alert.title.error.empty.option", comment: "Option can not be empty")
  static let longOption = NSLocalizedString("alert.title.error.long.option", comment: "Option can not be longer than three characters")
}
