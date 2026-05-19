import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }

class YourLibraryCollectionView_Hook: ClassHook<UICollectionView> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_CommonKit.YourLibraryCollectionView"
  
    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        guard let collectionView = target.view.subviews.first(where: { $0 is UICollectionView }) as? UICollectionView else { return }
        
        if let target = collectionView.subviews[safe: 2]?
            .subviews[safe: 0]?
            .subviews[safe: 0],
            target.accessibilityIdentifier == "LocalFiles.Row.Library" {
            target.removeFromSuperview()
            NSLog("[Omneon] removed LocalFiles.Row.Library")
        }
    }
}
