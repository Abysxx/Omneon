import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

var hiddenIndexPath_2: IndexPath? = nil

func scanAndHideCredits(in collectionView: UICollectionView) {
    for cell in collectionView.visibleCells {
        if containsIdentifier(cell, identifier: "TrackCredits.Card"),
           let indexPath = collectionView.indexPath(for: cell) {
            NSLog("[Omneon] HideCredits scan found target at \(indexPath)")
            if hiddenIndexPath_2 != indexPath {
                hiddenIndexPath_2 = indexPath
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            break
        }
    }
}

class HideCredits_ViewControllerHook: ClassHook<UIViewController> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollViewController"

    @objc(nowPlayingScrollViewModelWithDidLoadComponentsFor:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidLoadComponents(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidLoadComponents(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else {
            NSLog("[Omneon] HideCredits could not get collectionView on load")
            return
        }
        NSLog("[Omneon] HideCredits components loaded, scanning...")
        scanAndHideCredits(in: collectionView)
    }

    @objc(nowPlayingScrollViewModelWithDidMoveToRelativeTrack:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else {
            NSLog("[Omneon] HideCredits could not get collectionView on track move")
            return
        }
        NSLog("[Omneon] HideCredits track moved, resetting...")
        hiddenIndexPath_2 = nil
        scanAndHideCredits(in: collectionView)
    }
}

class HideCredits_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        let adjusted = hiddenIndexPath_2 != nil ? count - 1 : count
        NSLog("[Omneon] HideCredits numberOfItems: \(count) -> \(adjusted)")
        return adjusted
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hidden = hiddenIndexPath_2 else {
            // Haven't found the target yet, check this cell
            let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
            if containsIdentifier(cell, identifier: "TrackCredits.Card") {
                NSLog("[Omneon] HideCredits found target in cellForItemAt \(indexPath), reloading")
                hiddenIndexPath_2 = indexPath
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            return cell
        }
        let adjustedIndexPath = indexPath.item >= hidden.item
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        NSLog("[Omneon] HideCredits cellForItemAt \(indexPath) -> adjusted to \(adjustedIndexPath)")
        return orig.collectionView(collectionView, cellForItemAt: adjustedIndexPath)
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Catch cells that had subviews added asynchronously
        if hiddenIndexPath_2 == nil && containsIdentifier(cell, identifier: "TrackCredits.Card") {
            NSLog("[Omneon] HideCredits found target in willDisplay \(indexPath), reloading")
            hiddenIndexPath_2 = indexPath
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
