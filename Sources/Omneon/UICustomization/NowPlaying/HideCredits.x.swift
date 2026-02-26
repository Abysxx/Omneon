import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

class HideCredits_CellHook: ClassHook<UIView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollCellWithDynamicSizing"
    
    func didMoveToSuperview() {
        orig.didMoveToSuperview()
        var cls: AnyClass? = NSClassFromString("NowPlaying_ScrollImpl.NowPlayingScrollCellWithDynamicSizing")
        while let current = cls {
            var count: UInt32 = 0
            if let methods = class_copyMethodList(current, &count) {
                for i in 0..<Int(count) {
                    NSLog("[Omneon] [\(NSStringFromClass(current))] \(NSStringFromSelector(method_getName(methods[i])))")
                }
                free(methods)
            }
            cls = class_getSuperclass(current)
        }
    }
}
