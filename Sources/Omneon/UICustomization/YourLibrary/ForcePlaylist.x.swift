import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibrarySortingFilteringPickerController_Hook: ClassHook<NSObject> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_CommonKit.YourLibrarySortingFilteringPickerController"

    @objc(setDelegate:)
    func setDelegate(_ delegate: AnyObject) {
        NSLog("[Omneon] delegate class: \(NSStringFromClass(type(of: delegate)))")
        orig.setDelegate(delegate)
    }
}
