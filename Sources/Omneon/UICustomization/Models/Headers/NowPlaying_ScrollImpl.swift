import UIKit
import Foundation

@objc protocol ScrollCollectionViewWithDynamicSizingProtocol {
    @objc optional func reloadItemsAtIndexPaths(_ indexPaths: [IndexPath])
    @objc optional func insertItemsAtIndexPaths(_ indexPaths: [IndexPath])
    @objc optional func deleteItemsAtIndexPaths(_ indexPaths: [IndexPath])
    @objc optional func layoutSubviews()
    @objc optional var visibleCells: [UICollectionViewCell] { get }
    @objc optional func indexPathForCell(_ cell: UICollectionViewCell) -> IndexPath?
    @objc optional func layoutAttributesForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
}

@objc class ScrollCollectionViewWithDynamicSizing: UICollectionView, ScrollCollectionViewWithDynamicSizingProtocol { }
