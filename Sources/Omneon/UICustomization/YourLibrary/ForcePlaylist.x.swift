import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class NSObject_SortingFiltering_Hook: ClassHook<NSObject> {
    typealias Group = ForcePlaylist
    static let targetName = "NSObject"

    @objc(sortingFilteringPicker:selectedFilterRule:)
    func sortingFilteringPicker(_ picker: AnyObject, selectedFilterRule rule: AnyObject) {
        NSLog("[Omneon] FOUND delegate class: \(NSStringFromClass(type(of: target)))")
        NSLog("[Omneon] selectedFilterRule: \(rule)")
        orig.sortingFilteringPicker(picker, selectedFilterRule: rule)
    }

    @objc(sortingFilteringPicker:selectedSortRule:)
    func sortingFilteringPicker(_ picker: AnyObject, selectedSortRule rule: AnyObject) {
        NSLog("[Omneon] FOUND delegate class: \(NSStringFromClass(type(of: target)))")
        NSLog("[Omneon] selectedSortRule: \(rule)")
        orig.sortingFilteringPicker(picker, selectedSortRule: rule)
    }
}
