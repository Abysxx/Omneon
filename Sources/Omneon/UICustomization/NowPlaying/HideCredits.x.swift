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
            hiddenIndexPath_2 = indexPath
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
        NSLog("[Omneon] HideCredits track moved, resetting and scanning...")
        hiddenIndexPath_2 = nil
        scanAndHideCredits(in: collectionView)
    }
}

class HideCredits_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Omneon_EmptyCell")
        if indexPath == hiddenIndexPath_2 {
            NSLog("[Omneon] HideCredits returning empty cell for known index \(indexPath)")
            let empty = collectionView.dequeueReusableCell(withReuseIdentifier: "Omneon_EmptyCell", for: indexPath)
            empty.restorationIdentifier = "Omneon_EmptyCell"
            return empty
        }
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        if containsIdentifier(cell, identifier: "TrackCredits.Card") {
            NSLog("[Omneon] HideCredits found target in cellForItemAt \(indexPath), replacing")
            hiddenIndexPath_2 = indexPath
            let empty = collectionView.dequeueReusableCell(withReuseIdentifier: "Omneon_EmptyCell", for: indexPath)
            empty.restorationIdentifier = "Omneon_EmptyCell"
            return empty
        }
        return cell
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == hiddenIndexPath_2 {
            NSLog("[Omneon] HideCredits removing cell at known index \(indexPath)")
            orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
            DispatchQueue.main.async {
                cell.removeFromSuperview()
            }
            return
        }

        // Skip our own empty cells
        if cell.restorationIdentifier == "Omneon_EmptyCell" {
            NSLog("[Omneon] HideCredits skipping own empty cell at \(indexPath)")
            orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
            return
        }

        if containsIdentifier(cell, identifier: "TrackCredits.Card") {
            NSLog("[Omneon] HideCredits found target in willDisplay \(indexPath), reloading")
            hiddenIndexPath_2 = indexPath
            DispatchQueue.main.async {
                collectionView.reloadItems(at: [indexPath])
            }
        }

        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
