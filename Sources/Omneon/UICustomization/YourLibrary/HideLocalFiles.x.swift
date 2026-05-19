import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }

class YourLibraryCompositionalLayout_Hook: ClassHook<UICollectionViewLayout> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryCompositionalLayout"

    @objc(layoutAttributesForElementsInRect:)
    func layoutAttributesForElements(in rect: CGRect) -> AnyObject? {
        guard let attrs = orig.layoutAttributesForElements(in: rect) as? [UICollectionViewLayoutAttributes] else { return nil }
        for attr in attrs {
            if let cell = target.collectionView?.cellForItem(at: attr.indexPath),
               cell.reuseIdentifier == "YourLibraryListItemBinderIdentifier.localFilesRow.none" {
                attr.frame = .zero
                attr.isHidden = true
            }
        }
        return attrs as AnyObject
    }
}
