import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

// Track the index path to hide
var hiddenIndexPath_2: IndexPath? = nil

class HideCredits_CollectionViewHook: ClassHook<UICollectionView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()
        NSLog("[Omneon] Delegate: \(NSStringFromClass(type(of: target.delegate as AnyObject)))")
        for cell in target.visibleCells {
            if cell.subviews.contains(where: { subview in
                subview.subviews.contains(where: { $0.accessibilityIdentifier == "TrackCredits.Card" })
            }) {
                if let indexPath = target.indexPath(for: cell) {
                    if hiddenIndexPath_2 != indexPath {
                        hiddenIndexPath_2 = indexPath
                        target.collectionViewLayout.invalidateLayout()
                    }
                }
                cell.isHidden = true
                cell.isUserInteractionEnabled = false
                break
            }
        }
    }
}

class HideCredits_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == HideCreditsState.hiddenIndexPath {
            return .zero
        }
        return orig.collectionView(collectionView, layout: layout, sizeForItemAt: indexPath)
    }
}
