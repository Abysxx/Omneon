import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibrarySortingFilteringPickerController_Hook: ClassHook<NSObject> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_CommonKit.YourLibrarySortingFilteringPickerController"

    @objc(sortingFilteringPicker:selectedFilterRule:)
    func sortingFilteringPicker(_ picker: AnyObject, selectedFilterRule rule: AnyObject) {
        NSLog("[Omneon] selectedFilterRule: \(rule)")
        NSLog("[Omneon] selectedFilterRule class: \(NSStringFromClass(type(of: rule)))")
        orig.sortingFilteringPicker(picker, selectedFilterRule: rule)
    }

    @objc(sortingFilteringPicker:deselectedFilterRule:)
    func sortingFilteringPicker(_ picker: AnyObject, deselectedFilterRule rule: AnyObject) {
        NSLog("[Omneon] DeselectedFilterRule: \(rule)")
        NSLog("[Omneon] DeselectedFilterRule class: \(NSStringFromClass(type(of: rule)))")
        orig.sortingFilteringPicker(picker, deselectedFilterRule: rule)
    }

    @objc(sortingFilteringPicker:selectedSortRule:)
    func sortingFilteringPicker(_ picker: AnyObject, selectedSortRule rule: AnyObject) {
        NSLog("[Omneon] selectedSortRule: \(rule)")
        NSLog("[Omneon] selectedSortRule class: \(NSStringFromClass(type(of: rule)))")
        orig.sortingFilteringPicker(picker, selectedSortRule: rule)
    }

    @objc(didCancelSortingFilteringPicker:reason:)
    func didCancelSortingFilteringPicker(_ picker: AnyObject, reason: AnyObject) {
        NSLog("[Omneon] didCancelSortingFilteringPicker reason: \(reason)")
        NSLog("[Omneon] reason class: \(NSStringFromClass(type(of: reason)))")
        orig.didCancelSortingFilteringPicker(picker, reason: reason)
    }
}
