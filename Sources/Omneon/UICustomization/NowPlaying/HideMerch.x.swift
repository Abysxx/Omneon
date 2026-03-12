import Orion
import UIKit
import Foundation

struct HideMerch: HookGroup {}

var hiddenIndexPath_6: IndexPath? = nil

func scanAndHideMerch(in collectionView: UICollectionView) {
    for cell in collectionView.visibleCells {
        if containsIdentifier(cell, identifier: "MerchContainerCard"),
           let indexPath = collectionView.indexPath(for: cell) {
            if hiddenIndexPath_6 != indexPath {
                hiddenIndexPath_6 = indexPath
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            break
        }
    }
}

class HideMerch_ViewControllerHook: ClassHook<UIViewController> {
    typealias Group = HideMerch
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollViewController"

    @objc(nowPlayingScrollViewModelWithDidLoadComponentsFor:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidLoadComponents(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidLoadComponents(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else {
            return
        }
        scanAndHideMerch(in: collectionView)
    }

    @objc(nowPlayingScrollViewModelWithDidMoveToRelativeTrack:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else {
            return
        }
        hiddenIndexPath_6 = nil
        scanAndHideMerch(in: collectionView)
    }
}

class HideMerch_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideMerch
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        let adjusted = hiddenIndexPath_6 != nil ? count - 1 : count
        return adjusted
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hidden = hiddenIndexPath_6 else {
            // Haven't found the target yet, check this cell
            let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
            if containsIdentifier(cell, identifier: "MerchContainerCard") {
                hiddenIndexPath_6 = indexPath
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
        if hiddenIndexPath_6 == nil && containsIdentifier(cell, identifier: "MerchContainerCard") {
            hiddenIndexPath_6 = indexPath
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
