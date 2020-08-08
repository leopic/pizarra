import UIKit

extension GridViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {
      return
    }

    let option = screen.options[indexPath.row]
    guard let destiny = option.destination else {
      Logger.track.action("Tapped on option: \(option.label ?? "N/A")")
      cell.toggle()
      return
    }

    performSegue(withIdentifier: destiny.segueId, sender: option)
  }
}
