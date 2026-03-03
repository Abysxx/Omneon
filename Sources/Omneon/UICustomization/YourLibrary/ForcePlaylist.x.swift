import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class SPTSortingFilteringUIFactoryImplementation_Hook: ClassHook<NSObject> {
    typealias Group = ForcePlaylist
    static let targetName = "SPTSortingFilteringUIFactoryImplementation"

    @objc(createSortingFilteringPickerWithAvailableFilterRules:availableSortRules:selectedFilterRules:selectedSortRule:)
    func createSortingFilteringPickerWithAvailableFilterRules(_ filterRules: AnyObject, availableSortRules sortRules: AnyObject, selectedFilterRules selectedFilters: AnyObject, selectedSortRule sortRule: AnyObject) -> AnyObject {
        NSLog("[Omneon] availableFilterRules: \(filterRules)")
        NSLog("[Omneon] selectedFilterRules: \(selectedFilters)")
        NSLog("[Omneon] selectedSortRule: \(sortRule)")
        return orig.createSortingFilteringPickerWithAvailableFilterRules(filterRules, availableSortRules: sortRules, selectedFilterRules: selectedFilters, selectedSortRule: sortRule)
    }
}
