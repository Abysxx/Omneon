import Orion
import UIKit
import Foundation

struct HideAboutArtist: HookGroup {}

var hiddenIndexPath_3: IndexPath? = nil

// !!! DONT DELETE
// !!! Other functions depend on this
func containsIdentifier(_ view: UIView, identifier: String) -> Bool {
    if view.accessibilityIdentifier == identifier {
        return true
    }
    for subview in view.subviews {
        if containsIdentifier(subview, identifier: identifier) {
            return true
        }
    }
    return false
}

func scanAndHideBiography(in collectionView: UICollectionView) {
    for cell in collectionView.visibleCells {
        if containsIdentifier(cell, identifier: "Components.UI.ArtistBioCardNowPlayingView"),
           let indexPath = collectionView.indexPath(for: cell) {
            if hiddenIndexPath_3 != indexPath {
                hiddenIndexPath_3 = indexPath
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            break
        }
    }
}

class HideAboutArtist_ViewControllerHook: ClassHook<UIViewController> {
    typealias Group = HideAboutArtist
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollViewController"

    @objc(nowPlayingScrollViewModelWithDidLoadComponentsFor:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidLoadComponents(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidLoadComponents(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else {
            return
        }
        scanAndHideBiography(in: collectionView)
    }

    @objc(nowPlayingScrollViewModelWithDidMoveToRelativeTrack:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else {
            return
        }
        hiddenIndexPath_3 = nil
        scanAndHideBiography(in: collectionView)
    }
}

class HideAboutArtist_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideAboutArtist
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        let adjusted = hiddenIndexPath_3 != nil ? count - 1 : count
        return adjusted
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hidden = hiddenIndexPath_3 else {
            // Haven't found the target yet, check this cell
            let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
            if containsIdentifier(cell, identifier: "Components.UI.ArtistBioCardNowPlayingView") {
                hiddenIndexPath_3 = indexPath
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            return cell
        }
        let adjustedIndexPath = indexPath.item >= hidden.item
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        return orig.collectionView(collectionView, cellForItemAt: adjustedIndexPath)
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Catch cells that had subviews added asynchronously
        if hiddenIndexPath_3 == nil && containsIdentifier(cell, identifier: "Components.UI.ArtistBioCardNowPlayingView") {
            hiddenIndexPath_3 = indexPath
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
