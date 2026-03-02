import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibraryViewController_Hook: ClassHook<UIViewController> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        var count: UInt32 = 0
        let ivars = class_copyIvarList(type(of: target), &count)
        for i in 0..<Int(count) {
            if let ivar = ivars?[i] {
                let name = String(cString: ivar_getName(ivar)!)
                let value = target.value(forKey: name)
                NSLog("[Omneon] ivar \(name): \(String(describing: value))")
            }
        }
        free(ivars)
    }
}
