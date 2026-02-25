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
        NSLog("[Omenon] Delegate: \(NSStringFromClass(type(of: target.delegate)))")
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

class HideCredits_LayoutHook: ClassHook<UICollectionViewLayout> {
    typealias Group = HideCredits

    // Match the layout used by the target collection view
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollLayout"
    @objc(prepareLayout)
    func prepareLayout() {
        orig.prepareLayout()
        
        if let hidden = hiddenIndexPath_2,
           let attr = target.layoutAttributesForItem(at: hidden) {
            attr.frame = .zero
            attr.isHidden = true
        }
    }
}
