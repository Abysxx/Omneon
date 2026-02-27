import Orion
import UIKit
import Foundation

struct HideLyricsCard: HookGroup {}

var hiddenIndexPath_4: IndexPath? = nil

func scanAndHideLyricsCard(in collectionView: UICollectionView) {
    for cell in collectionView.visibleCells {
        if containsIdentifier(cell, identifier: "lyrics-card-view"),
           let indexPath = collectionView.indexPath(for: cell) {
            if hiddenIndexPath_4 != indexPath {
                hiddenIndexPath_4 = indexPath
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            break
        }
    }
}

class HideLyricsCard_ViewControllerHook: ClassHook<UIViewController> {
    typealias Group = HideLyricsCard
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollViewController"

    @objc(nowPlayingScrollViewModelWithDidLoadComponentsFor:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidLoadComponents(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidLoadComponents(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else {
            return
        }
        scanAndHideLyricsCard(in: collectionView)
    }

    @objc(nowPlayingScrollViewModelWithDidMoveToRelativeTrack:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else {
            return
        }
        hiddenIndexPath_4 = nil
        scanAndHideLyricsCard(in: collectionView)
    }
}

class HideLyricsCard_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideLyricsCard
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        let adjusted = hiddenIndexPath_4 != nil ? count - 1 : count
        return adjusted
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hidden = hiddenIndexPath_4 else {
            // Haven't found the target yet, check this cell
            let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
            if containsIdentifier(cell, identifier: "lyrics-card-view") {
                hiddenIndexPath_4 = indexPath
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
        if hiddenIndexPath_4 == nil && containsIdentifier(cell, identifier: "lyrics-card-view") {
            hiddenIndexPath_4 = indexPath
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
