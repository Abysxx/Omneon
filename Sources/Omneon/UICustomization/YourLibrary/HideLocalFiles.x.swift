import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }
var localFilesIndex: Int? = nil

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
