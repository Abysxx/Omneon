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
        var count: UInt32 = 0
        if let methods = class_copyMethodList(NSClassFromString("NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"), &count) {
            for i in 0..<Int(count) {
                NSLog("[Omneon] Method: \(NSStringFromSelector(method_getName(methods[i])))")
            }
            free(methods)
        }
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

