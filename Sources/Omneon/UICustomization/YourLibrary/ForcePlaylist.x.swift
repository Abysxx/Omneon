import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibraryHeaderContentFiltersView_Hook: ClassHook<UIView> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_CommonKit.YourLibraryHeaderContentFiltersView"

    @objc(initWithFrame:)
    func initWithFrame(_ frame: CGRect) -> AnyObject {
        let result = orig.initWithFrame(frame)
        NSLog("[Omneon] YourLibraryHeaderContentFiltersView init: \(result)")
        // log subviews to find the collection view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NSLog("[Omneon] subviews: \((result as AnyObject).subviews as Any)")
        }
        return result
    }
}
