import UIKit

extension GridViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    answers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emotionCell", for: indexPath) as? CollectionViewCell else {
      return UICollectionViewCell()
    }

    cell.option = screen.options[indexPath.row]

    return cell
  }
}
