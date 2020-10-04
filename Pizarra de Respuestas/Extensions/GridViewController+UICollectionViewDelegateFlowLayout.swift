import UIKit

extension GridViewController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemsInSection = collectionView.numberOfItems(inSection: indexPath.section)
//    let horizontalSpace = Self.sectionInsets.left * (CGFloat(itemsInSection) + 1)

    let availableWidth = (view.frame.width - Self.sectionInsets.left * 2) / CGFloat(itemsInSection + 1)
//    let widthPerItem = availableWidth / itemsPerRow
//
//    let itemsInSection = collectionView.numberOfItems(inSection: indexPath.section)
//    let totalItems = CGFloat(itemsInSection.isMultiple(of: 2) ? itemsInSection : (itemsInSection + 1))
//    let verticalSpace = Self.sectionInsets.bottom * (itemsPerColumn + 1)
//    let availableHeight = view.frame.height - verticalSpace
//
//    let heightPerItem: CGFloat
//    if totalItems == itemsPerColumn {
//      heightPerItem = availableHeight + Self.sectionInsets.bottom
//    } else {
//      heightPerItem = availableHeight / (totalItems / itemsPerColumn)
//    }
//
//    return CGSize(width: widthPerItem, height: heightPerItem)
    return CGSize(width: availableWidth, height: availableWidth)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
//    let itemsInSection = collectionView.numberOfItems(inSection: 0)
//    let availableWidth = (view.frame.width - Self.sectionInsets.left * 2) / CGFloat(itemsInSection + 1)
//
//    let superInsets = self.collectionView(layout)
//    let tmp = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
//    print("super: \(tmp)")
//    let tmp = collectionView.section
    var insets = Self.sectionInsets
//
//    let size = collectionView.frame.height/2
//    insets.top = size
//    insets.bottom = size
//


    collectionView.contentInset.top = max((collectionView.frame.height - collectionView.contentSize.height) / 2, 0)
    
    return insets
////    Self.sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    Self.sectionInsets.left
  }
}
