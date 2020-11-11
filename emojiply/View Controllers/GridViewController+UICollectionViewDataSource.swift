import UIKit

extension GridViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    screen.options.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseId.emotionCell, for: indexPath) as? AnswerCell else {
      return UICollectionViewCell()
    }

    cell.option = screen.options[indexPath.row]

    return cell
  }
}
