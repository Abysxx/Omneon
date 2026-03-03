import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibraryViewController_Hook: ClassHook<UIViewController> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"
    
    func viewDidLoad() {
        orig.viewDidLoad()
        var count: UInt32 = 0
        guard let ivars = class_copyIvarList(type(of: target), &count) else { return }
        for i in 0..<Int(count) {
            guard let name = ivar_getName(ivars[i]).map({ String(cString: $0) }) else { continue }
            let value = object_getIvar(target, ivars[i])
            guard let value = value else { continue }
            NSLog("[Omneon] \(name): \(value)")
        }
        free(ivars)
    }
}
