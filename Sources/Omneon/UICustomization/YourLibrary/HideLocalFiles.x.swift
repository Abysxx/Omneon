import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }
var localFilesIndex: Int? = nil

class HideLocalFiles_DataSourceHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryContentViewBinder"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        var found: Int? = nil
        for i in 0..<count {
            let cell = orig.collectionView(collectionView, cellForItemAt: IndexPath(item: i, section: section))
            if cell.reuseIdentifier == "YourLibraryListItemBinderIdentifier.localFilesRow.none" {
                found = i
                break
            }
        }
        localFilesIndex = found
        return found != nil ? count - 1 : count
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hidden = localFilesIndex else {
            return orig.collectionView(collectionView, cellForItemAt: indexPath)
        }
        let adjusted = indexPath.item >= hidden
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        return orig.collectionView(collectionView, cellForItemAt: adjusted)
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let hidden = localFilesIndex else {
            orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
            return
        }
        let adjusted = indexPath.item >= hidden
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: adjusted)
    }

    @objc(collectionView:didSelectItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hidden = localFilesIndex else {
            orig.collectionView(collectionView, didSelectItemAt: indexPath)
            return
        }
        let adjusted = indexPath.item >= hidden
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        orig.collectionView(collectionView, didSelectItemAt: adjusted)
    }
}

class HideLocalFiles_SortingFilteringHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_CommonKit.YourLibrarySortingFilteringPickerController"

    @objc(sortingFilteringPicker:selectedSortRule:)
    func sortingFilteringPicker(_ picker: AnyObject, selectedSortRule rule: AnyObject) {
        NSLog("[Omneon] selectedSortRule: \(rule)")
        NSLog("[Omneon] selectedSortRule class: \(NSStringFromClass(type(of: rule)))")
        localFilesIndex = nil
        orig.sortingFilteringPicker(picker, selectedSortRule: rule)
    }

    @objc(sortingFilteringPicker:selectedFilterRule:)
    func sortingFilteringPicker(_ picker: AnyObject, selectedFilterRule rule: AnyObject) {
        NSLog("[Omneon] selectedFilterRule: \(rule)")
        NSLog("[Omneon] selectedFilterRule class: \(NSStringFromClass(type(of: rule)))")
        localFilesIndex = nil
        orig.sortingFilteringPicker(picker, selectedFilterRule: rule)
    }

    @objc(sortingFilteringPicker:deselectedFilterRule:)
    func sortingFilteringPicker(_ picker: AnyObject, deselectedFilterRule rule: AnyObject) {
        NSLog("[Omneon] deselectedFilterRule: \(rule)")
        NSLog("[Omneon] deselectedFilterRule class: \(NSStringFromClass(type(of: rule)))")
        localFilesIndex = nil
        orig.sortingFilteringPicker(picker, deselectedFilterRule: rule)
    }

    @objc(didCancelSortingFilteringPicker:reason:)
    func didCancelSortingFilteringPicker(_ picker: AnyObject, reason: UInt) {
        NSLog("[Omneon] didCancelSortingFilteringPicker reason: \(reason)")
        orig.didCancelSortingFilteringPicker(picker, reason: reason)
    }
}
