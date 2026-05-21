import Orion
import UIKit
import SwiftUI
import ObjectiveC.runtime

// MARK: - Helpers

func logIvars(_ obj: AnyObject, className: String? = nil) {
    let actualClass: AnyClass = className.flatMap(NSClassFromString) ?? type(of: obj)

    NSLog("========== IVARS FOR \(NSStringFromClass(actualClass)) ==========")

    var count: UInt32 = 0

    guard let ivars = class_copyIvarList(actualClass, &count) else {
        NSLog("[Omneon] No ivars found")
        return
    }

    defer {
        free(ivars)
    }

    for i in 0..<Int(count) {
        let ivar = ivars[i]

        guard let name = ivar_getName(ivar) else { continue }

        let ivarName = String(cString: name)

        if let value = object_getIvar(obj, ivar) {
            NSLog("[Omneon] \(ivarName): \(value)")
        } else {
            NSLog("[Omneon] \(ivarName): nil")
        }
    }
}

func logProperties(_ obj: AnyObject, className: String? = nil) {
    let actualClass: AnyClass = className.flatMap(NSClassFromString) ?? type(of: obj)

    NSLog("========== PROPERTIES FOR \(NSStringFromClass(actualClass)) ==========")

    var count: UInt32 = 0

    guard let properties = class_copyPropertyList(actualClass, &count) else {
        NSLog("[Omneon] No properties found")
        return
    }

    defer {
        free(properties)
    }

    for i in 0..<Int(count) {
        let property = properties[i]

        guard let name = property_getName(property) else { continue }

        let propName = String(cString: name)

        if let value = obj.value(forKey: propName) {
            NSLog("[Omneon] \(propName): \(value)")
        } else {
            NSLog("[Omneon] \(propName): nil")
        }
    }
}

func logEverything(_ obj: AnyObject, name: String? = nil) {
    let cls = name ?? NSStringFromClass(type(of: obj))

    NSLog("===================================================")
    NSLog("[Omneon] LOGGING OBJECT: \(cls)")
    NSLog("[Omneon] INSTANCE: \(obj)")
    NSLog("===================================================")

    logProperties(obj)
    logIvars(obj)
}

// MARK: - Hook Group

struct HideLocalFiles: HookGroup { }

// MARK: - Sort Rule

class SortRuleHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "_TtCV21YourLibrary_CommonKit31YourLibrarySortOptionPickerData8SortRule"

    func identifier() -> AnyObject {
        let result = orig.identifier()

        NSLog("[Omneon] SortRule.identifier -> \(result)")

        return result
    }

    func title() -> AnyObject {
        let result = orig.title()

        NSLog("[Omneon] SortRule.title -> \(result)")

        return result
    }

    func ascendingOrder() -> Bool {
        let result = orig.ascendingOrder()

        NSLog("[Omneon] SortRule.ascendingOrder -> \(result)")

        return result
    }

    func isEqual(_ other: AnyObject?) -> Bool {
        NSLog("[Omneon] SortRule.isEqual: \(String(describing: other))")

        return orig.isEqual(other)
    }

    func `init`() -> AnyObject {
        let obj = orig.init()

        NSLog("[Omneon] SortRule.init")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }
}

// MARK: - Selected Sort Order Impl

class SelectedSortOrderImplHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibrarySelectedSortOrderImpl"

    func `init`() -> AnyObject {
        let obj = orig.init()

        NSLog("[Omneon] YourLibrarySelectedSortOrderImpl.init")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }
}

// MARK: - Local Settings Observer

class LocalSettingsObserverHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "_TtC28YourLibrary_YourLibraryXImpl49YourLibrarySelectedSortOrderLocalSettingsObserver"

    func `init`() -> AnyObject {
        let obj = orig.init()

        NSLog("[Omneon] LocalSettingsObserver.init")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }
}

// MARK: - Sort/Filter Options Provider

class SortAndFilterProviderHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "Collection_DataLoaderImpl.CollectionDataLoaderSortAndFilterOptionsProviderImpl"

    func `init`() -> AnyObject {
        let obj = orig.init()

        NSLog("[Omneon] CollectionDataLoaderSortAndFilterOptionsProviderImpl.init")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }
}

// MARK: - Sorting Filtering Picker

class SortingFilteringPickerHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_CommonKit.YourLibrarySortingFilteringPickerController"

    @objc(sortingFilteringPicker:selectedSortRule:)
    func sortingFilteringPicker(_ picker: AnyObject, selectedSortRule rule: AnyObject) {
        NSLog("===================================================")
        NSLog("[Omneon] selectedSortRule")
        NSLog("===================================================")

        NSLog("[Omneon] rule: \(rule)")
        NSLog("[Omneon] class: \(NSStringFromClass(type(of: rule)))")

        logEverything(rule)

        orig.sortingFilteringPicker(picker, selectedSortRule: rule)
    }

    @objc(sortingFilteringPicker:selectedFilterRule:)
    func sortingFilteringPicker(_ picker: AnyObject, selectedFilterRule rule: AnyObject) {
        NSLog("===================================================")
        NSLog("[Omneon] selectedFilterRule")
        NSLog("===================================================")

        NSLog("[Omneon] rule: \(rule)")
        NSLog("[Omneon] class: \(NSStringFromClass(type(of: rule)))")

        logEverything(rule)

        orig.sortingFilteringPicker(picker, selectedFilterRule: rule)
    }

    @objc(sortingFilteringPicker:deselectedFilterRule:)
    func sortingFilteringPicker(_ picker: AnyObject, deselectedFilterRule rule: AnyObject) {
        NSLog("===================================================")
        NSLog("[Omneon] deselectedFilterRule")
        NSLog("===================================================")

        NSLog("[Omneon] rule: \(rule)")
        NSLog("[Omneon] class: \(NSStringFromClass(type(of: rule)))")

        logEverything(rule)

        orig.sortingFilteringPicker(picker, deselectedFilterRule: rule)
    }

    @objc(didCancelSortingFilteringPicker:reason:)
    func didCancelSortingFilteringPicker(_ picker: AnyObject, reason: UInt) {
        NSLog("[Omneon] didCancelSortingFilteringPicker reason: \(reason)")

        orig.didCancelSortingFilteringPicker(picker, reason: reason)
    }
}

// MARK: - Header Content Filters View

class HeaderContentFiltersViewHook: ClassHook<UIView> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_CommonKit.YourLibraryHeaderContentFiltersView"

    func initWithFrame(_ frame: CGRect) -> AnyObject {
        let obj = orig.initWithFrame(frame)

        NSLog("[Omneon] HeaderContentFiltersView.initWithFrame")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }

    func initWithCoder(_ coder: NSCoder) -> AnyObject {
        let obj = orig.initWithCoder(coder)

        NSLog("[Omneon] HeaderContentFiltersView.initWithCoder")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }
}

// MARK: - Filter Chips Provider Config

class FilterChipsProviderConfigHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "CollectionSongs_PlaylistImpl.CSFilterChipsProviderConfig"

    @objc(filterDataLoaderLoaded:filters:)
    func filterDataLoaderLoaded(_ loader: AnyObject, filters: AnyObject) {
        NSLog("[Omneon] filterDataLoaderLoaded")
        NSLog("[Omneon] loader: \(loader)")
        NSLog("[Omneon] filters: \(filters)")

        logEverything(filters)

        orig.filterDataLoaderLoaded(loader, filters: filters)
    }

    @objc(filterDataLoaderError:error:)
    func filterDataLoaderError(_ loader: AnyObject, error: AnyObject) {
        NSLog("[Omneon] filterDataLoaderError")
        NSLog("[Omneon] loader: \(loader)")
        NSLog("[Omneon] error: \(error)")

        orig.filterDataLoaderError(loader, error: error)
    }

    func `init`() -> AnyObject {
        let obj = orig.init()

        NSLog("[Omneon] CSFilterChipsProviderConfig.init")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }
}

// MARK: - Songs Filter Impl

class SongsFilterImplHook: ClassHook<NSObject> {
    typealias Group = YourLibraryLoggerHooks
    static let targetName = "CollectionSongs_SongsImpl.SongsFilterImpl"

    func query() -> AnyObject {
        let result = orig.query()

        NSLog("[Omneon] SongsFilterImpl.query -> \(result)")

        return result
    }

    @objc(setQuery:)
    func setQuery(_ query: AnyObject) {
        NSLog("[Omneon] SongsFilterImpl.setQuery -> \(query)")

        orig.perform(Selector(("setQuery:")), with: query)
    }

    func title() -> AnyObject {
        let result = orig.title()

        NSLog("[Omneon] SongsFilterImpl.title -> \(result)")

        return result
    }

    @objc(setTitle:)
    func setTitle(_ title: AnyObject) {
        NSLog("[Omneon] SongsFilterImpl.setTitle -> \(title)")

        orig.perform(Selector(("setTitle:")), with: title)
    }

    func `init`() -> AnyObject {
        let obj = orig.init()

        NSLog("[Omneon] SongsFilterImpl.init")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }
}

// MARK: - Content View Binder

class ContentViewBinderHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryContentViewBinder"

    func collectionView(_ collectionView: AnyObject, didSelectItemAt indexPath: AnyObject) {
        NSLog("[Omneon] didSelectItemAtIndexPath: \(indexPath)")

        orig.collectionView(collectionView, didSelectItemAt: indexPath)
    }

    func scrollViewDidScrollToTop(_ scrollView: AnyObject) {
        NSLog("[Omneon] scrollViewDidScrollToTop")

        orig.scrollViewDidScrollToTop(scrollView)
    }

    func `init`() -> AnyObject {
        let obj = orig.init()

        NSLog("[Omneon] YourLibraryContentViewBinder.init")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }
}

// MARK: - Header View Binder

class HeaderViewBinderHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryHeaderViewBinder"

    func `init`() -> AnyObject {
        let obj = orig.init()

        NSLog("[Omneon] YourLibraryHeaderViewBinder.init")

        if let o = obj as? AnyObject {
            logEverything(o)
        }

        return obj
    }
}
