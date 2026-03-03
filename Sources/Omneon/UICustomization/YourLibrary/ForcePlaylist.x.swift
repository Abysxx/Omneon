import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibraryViewController_Hook: ClassHook<UIViewController> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        let count = objc_getClassList(nil, 0)
        var classes = [AnyClass](repeating: NSObject.self, count: Int(count))
        classes.withUnsafeMutableBufferPointer { buf in
            objc_getClassList(AutoreleasingUnsafeMutablePointer(buf.baseAddress!), count)
        }
        var output = ""
        for cls in classes {
            var methodCount: UInt32 = 0
            let methods = class_copyMethodList(cls, &methodCount)
            for i in 0..<Int(methodCount) {
                if let method = methods?[i] {
                    let sel = NSStringFromSelector(method_getName(method))
                    if sel.lowercased().contains("sortingfiltering") {
                        output += "class: \(NSStringFromClass(cls)) method: \(sel)\n"
                    }
                }
            }
            free(methods)
        }
        let path = "/var/jb/var/mobile/Documents/sortingfiltering_dump.txt"
        try? output.write(toFile: path, atomically: true, encoding: .utf8)
        NSLog("[Omneon] dumped to \(path)")
    }
}
