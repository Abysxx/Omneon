import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

var hiddenIndexPath_2: IndexPath? = nil

func scanAndHideCredits(in collectionView: UICollectionView) {
    for cell in collectionView.visibleCells {
        if containsIdentifier(cell, identifier: "TrackCredits.Card"),
           let indexPath = collectionView.indexPath(for: cell) {
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

    @objc(nowPlayingScrollViewModelWithDidLoadComponentsFor:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidLoadComponents(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidLoadComponents(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else { return }
        scanAndHideCredits(in: collectionView)
    }

    @objc(nowPlayingScrollViewModelWithDidMoveToRelativeTrack:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else { return }
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
            return collectionView.dequeueReusableCell(withReuseIdentifier: "Omneon_EmptyCell", for: indexPath)
        }
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        if containsIdentifier(cell, identifier: "TrackCredits.Card") {
            hiddenIndexPath_2 = indexPath
            return collectionView.dequeueReusableCell(withReuseIdentifier: "Omneon_EmptyCell", for: indexPath)
        }
        return cell
    }
    
    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == hiddenIndexPath_2 {
            cell.isHidden = true
            orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
            return
        }
        
        if containsIdentifier(cell, identifier: "TrackCredits.Card") {
            hiddenIndexPath_2 = indexPath
            DispatchQueue.main.async {
                collectionView.reloadItems(at: [indexPath])
            }
        }
        
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
