import Orion
import UIKit

struct HideExplore: HookGroup { }

class ScrollCollectionViewHook_0: ClassHook<NSObject> {
    typealias Group = HideExplore
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    // The class we want to hide
    private let hiddenClassName = "WatchFeed_NPVProviderImpl.WatchFeedNPVView"

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        
        // Recursively check if any descendant view matches the class name
        func containsHiddenClass(_ view: UIView) -> Bool {
            let viewClassName = NSStringFromClass(type(of: view))
            if viewClassName == hiddenClassName { return true }
            for subview in view.subviews {
                if containsHiddenClass(subview) { return true }
            }
            return false
        }
        
        if containsHiddenClass(cell) {
            cell.isHidden = true
            cell.alpha = 0
            cell.contentView.isHidden = true
            cell.isUserInteractionEnabled = false
            NSLog("[Omneon] Hiding cell at \(indexPath) because it contains \(hiddenClassName)")
        }
        
        return cell
    }
}
