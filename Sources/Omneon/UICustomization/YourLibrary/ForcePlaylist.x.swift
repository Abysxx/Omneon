import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibraryViewController_Hook: ClassHook<UIViewController> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let filtersView = self.target.view.subviews.first?
                .subviews.first?
                .subviews.first?
                .subviews.first else { return }
            
            if let collectionView = filtersView.subviews.first(where: { 
                $0.accessibilityIdentifier == "Layout.CollectionView" 
            }) as? UICollectionView {
                let indexPath = IndexPath(item: 1, section: 0)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
                NSLog("[Omneon] forced playlist filter selection")
            }
        }
    }
}
