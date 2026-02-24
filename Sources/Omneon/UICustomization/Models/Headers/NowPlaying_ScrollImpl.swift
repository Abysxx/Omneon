import UIKit
import Foundation

@objc protocol ScrollCollectionViewWithDynamicSizingProtocol {
    @objc optional func reloadItems(at indexPaths: [IndexPath])
    @objc optional func insertItems(at indexPaths: [IndexPath])
    @objc optional func deleteItems(at indexPaths: [IndexPath])
    @objc optional func layoutSubviews()
    @objc optional var visibleCells: [UICollectionViewCell] { get }
    @objc optional func indexPath(for cell: UICollectionViewCell) -> IndexPath?
    @objc optional func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
}
