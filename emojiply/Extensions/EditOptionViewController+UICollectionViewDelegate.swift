import UIKit

extension EditOptionViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedColor = Self.colorList[indexPath.row]
    collectionView.reloadData()
  }
}
