import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }

class YourLibraryCollectionView_Hook: ClassHook<UICollectionView> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_CommonKit.YourLibraryCollectionView"
  
    func layoutSubviews() {
        orig.layoutSubviews()
        for subview in target.subviews {
            if let view = subview.subviews[safe: 2]?
                .subviews[safe: 0]?
                .subviews[safe: 0],
                view.accessibilityIdentifier == "LocalFiles.Row.Library" {
                view.isHidden = true
                NSLog("[Omneon] hidden LocalFiles.Row.Library")
            }
        }
    }
}
