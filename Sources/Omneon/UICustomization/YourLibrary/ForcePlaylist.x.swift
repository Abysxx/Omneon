import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class SPTSortingFilteringPickerDelegate_Hook: ClassHook<NSObject> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_CommonKit.YourLibrarySortingFilteringPickerController"

    @objc(sortingFilteringPicker:selectedFilterRule:)
    func sortingFilteringPicker(_ picker: AnyObject, selectedFilterRule rule: AnyObject) {
        NSLog("[Omneon] selectedFilterRule: \(rule)")
        NSLog("[Omneon] selectedFilterRule class: \(NSStringFromClass(type(of: rule)))")
        orig.sortingFilteringPicker(picker, selectedFilterRule: rule)
    }
}
