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
                let typeEncoding = String(cString: ivar_getTypeEncoding(ivar)!)
                // only attempt to get object types (start with @)
                if typeEncoding.hasPrefix("@") {
                    let value = object_getIvar(target, ivar)
                    NSLog("[Omneon] ivar \(name) (\(typeEncoding)): \(String(describing: value))")
                } else {
                    NSLog("[Omneon] ivar \(name) (\(typeEncoding)): <non-object>")
                }
            }
        }
        free(ivars)
    }
}
