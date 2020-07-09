import UIKit

extension GridViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {
      return
    }

    let option = screen.options[indexPath.row]
    guard let destiny = option.destination else {
      cell.toggle()
      return
    }

    performSegue(withIdentifier: destiny.segueId, sender: option)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destination = segue.destination as? GridViewController,
          let option = sender as? Option,
          let screen = option.destination?.screen else {
      return
    }

    destination.screen = screen
  }
}
