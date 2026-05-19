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
}
