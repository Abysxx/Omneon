import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class NowPlaying_ModesImpl_InformationElementsUnit_Hook_2: ClassHook<UIViewController> {
    typealias Group = ForcePlaylist
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"
    
    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        let count = objc_getClassList(nil, 0)
        var classes = [AnyClass](repeating: NSObject.self, count: Int(count))
        classes.withUnsafeMutableBufferPointer { buf in
            objc_getClassList(AutoreleasingUnsafeMutablePointer(buf.baseAddress!), count)
        }
        var output = ""
        for cls in classes {
            let className = NSStringFromClass(cls)
            guard className.lowercased().contains("yourlibrary") else { continue }
            var methodCount: UInt32 = 0
            let methods = class_copyMethodList(cls, &methodCount)
            for i in 0..<Int(methodCount) {
                if let method = methods?[i] {
                    let sel = NSStringFromSelector(method_getName(method))
                    output += "\(className) -> \(sel)\n"
                }
            }
            free(methods)
        }
        let path = "/var/jb/var/mobile/Documents/yourlibrary_methods.txt"
        try? output.write(toFile: path, atomically: true, encoding: .utf8)
        NSLog("[Omneon] dumped to \(path)")
    }
}
