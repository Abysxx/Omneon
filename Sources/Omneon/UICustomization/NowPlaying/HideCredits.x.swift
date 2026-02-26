import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

class HideCredits_CollectionViewHook: ClassHook<UICollectionView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    @objc(insertItemsAtIndexPaths:)
    func insertItems(at indexPaths: [IndexPath]) {
        orig.insertItems(at: indexPaths)
        NSLog("[Omneon] IndexPaths: \(indexPaths)")
        for indexPath in indexPaths {
            if let cell = target.cellForItem(at: indexPath),
               containsIdentifier(cell, identifier: "TrackCredits.Card") {
                hiddenIndexPath_2 = indexPath
                cell.isHidden = true
            }
        }
    }

    @objc(insertSections:)
    func insertSections(_ sections: IndexSet) {
        orig.insertSections(sections)
        NSLog("[Omneon] Sections: \(sections)")
    }
}
