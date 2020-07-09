import UIKit

extension GridViewController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let horizontalSpace = sectionInsets.left * (itemsPerRow + 1)

    let availableWidth = collectionView.frame.width - horizontalSpace
    let widthPerItem = availableWidth / itemsPerRow

    let itemsInSection = collectionView.numberOfItems(inSection: indexPath.section)
    let totalItems = CGFloat(itemsInSection.isMultiple(of: 2) ? itemsInSection : (itemsInSection + 1))
    let verticalSpace = sectionInsets.bottom * (itemsPerColumn + 1)
    let availableHeight = collectionView.frame.height - verticalSpace

    let heightPerItem: CGFloat
    if totalItems == itemsPerColumn {
      heightPerItem = availableHeight + sectionInsets.bottom
    } else {
      heightPerItem = availableHeight / (totalItems / itemsPerColumn)
    }

    return CGSize(width: widthPerItem, height: heightPerItem)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    sectionInsets.left
  }
}
