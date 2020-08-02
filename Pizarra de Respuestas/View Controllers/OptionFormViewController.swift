import Foundation
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
    guard let index = self.index else { return }
    screen.options.remove(at: index)
    navigationController?.popViewController(animated: true)
  }

  var screen: AScreen!
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
    .white,
    .systemGray,
    .black,
    .clear
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationItem.title = index == nil ? "Crear" : "Editar"

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

extension OptionFormViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    Self.colorList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)

    let color = Self.colorList[indexPath.row]
    cell.contentView.backgroundColor = color == .clear ? color : color.withAlphaComponent(0.5)
    cell.contentView.layer.borderColor = Color.label.withAlphaComponent(0.25).cgColor
    cell.contentView.layer.borderWidth = 1
    cell.contentView.layer.cornerRadius = 8

    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    label.textAlignment = .center
    label.accessibilityIdentifier = "Selected"

    cell.contentView.subviews.first(where: { $0 is UILabel })?.removeFromSuperview()

    if selectedColor == color {
      cell.contentView.layer.borderWidth = 3
      label.text = "X"
      label.shadowColor = ColorCompatibility.systemBackground.withAlphaComponent(0.25)
      label.shadowOffset = CGSize(width: 1, height: 1)
      label.font = UIFont(name: "Helvetica-Neue Thin", size: 24.0)
      cell.contentView.addSubview(label)
    }

    return cell
  }
}

extension OptionFormViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedColor = Self.colorList[indexPath.row]
    collectionView.reloadData()
  }
}

extension OptionFormViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 64.0, height: 64.0)
  }
}
