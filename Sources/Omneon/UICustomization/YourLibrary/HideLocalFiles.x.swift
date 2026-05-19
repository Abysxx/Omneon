import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }

class YourLibraryCompositionalLayout_Hook: ClassHook<UICollectionViewLayout> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryCompositionalLayout"

    @objc(layoutAttributesForItemAtIndexPath:)
    func layoutAttributesForItem(at indexPath: IndexPath) -> AnyObject? {
        guard let attrs = orig.layoutAttributesForItem(at: indexPath) else { return nil }
        if let cell = target.collectionView?.cellForItem(at: indexPath),
           let view = cell.subviews[safe: 2]?.subviews[safe: 0]?.subviews[safe: 0],
           view.accessibilityIdentifier == "LocalFiles.Row.Library" {
            (attrs as? UICollectionViewLayoutAttributes)?.frame = .zero
            (attrs as? UICollectionViewLayoutAttributes)?.isHidden = true
        }
        return attrs
    }
}
