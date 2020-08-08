import UIKit
import ColorCompatibility

extension OptionFormViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    Self.colorList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseId.colorCell, for: indexPath)

    let color = Self.colorList[indexPath.row]
    cell.contentView.backgroundColor = color == .clear ? color : color.withAlphaComponent(0.5)
    cell.contentView.layer.borderColor = Color.label.withAlphaComponent(0.25).cgColor
    cell.contentView.layer.borderWidth = 1
    cell.contentView.layer.cornerRadius = 8

    cell.contentView.subviews.first(where: { $0 is UILabel })?.removeFromSuperview()

    if selectedColor == color {
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: swatchSize, height: swatchSize))
      label.textAlignment = .center
      label.accessibilityIdentifier = "Selected"
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
