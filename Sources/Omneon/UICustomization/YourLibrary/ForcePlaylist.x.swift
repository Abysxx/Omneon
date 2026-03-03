import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibrarySortingFilteringPickerController_Hook: ClassHook<NSObject> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_CommonKit.YourLibrarySortingFilteringPickerController"

    @objc(init)
    func `init`() -> AnyObject {
        let result = orig.`init`()
        let symbols = Thread.callStackSymbols
        for symbol in symbols.prefix(10) {
            NSLog("[Omneon] stack: \(symbol)")
        }
        return result
    }
}
