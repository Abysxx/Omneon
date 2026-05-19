import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }

class YourLibraryCollectionView_Hook: ClassHook<UICollectionView> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_CommonKit.YourLibraryCollectionView"

    func layoutSubviews() {
        orig.layoutSubviews()
        for cell in target.visibleCells {
            if let view = cell.subviews[safe: 2]?.subviews[safe: 0]?.subviews[safe: 0],
               view.accessibilityIdentifier == "LocalFiles.Row.Library" {
                cell.isHidden = true
                cell.frame = .zero
            }
        }
    }

    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, layout: AnyObject, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cell = target.cellForItem(at: indexPath),
           let view = cell.subviews[safe: 2]?.subviews[safe: 0]?.subviews[safe: 0],
           view.accessibilityIdentifier == "LocalFiles.Row.Library" {
            return .zero
        }
        return orig.collectionView(collectionView, layout: layout, sizeForItemAt: indexPath)
    }
    
}
