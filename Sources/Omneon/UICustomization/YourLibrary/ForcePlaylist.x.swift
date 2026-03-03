import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibraryViewController_Hook: ClassHook<UIViewController> {
    typealias Group = ForcePlaylist
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        
        let count = objc_getClassList(nil, 0)
        var classes = [AnyClass](repeating: NSObject.self, count: Int(count))
        classes.withUnsafeMutableBufferPointer { buf in
            objc_getClassList(AutoreleasingUnsafeMutablePointer(buf.baseAddress!), count)
        }
        for cls in classes {
            let name = NSStringFromClass(cls)
            if name.lowercased().contains("collection") || name.lowercased().contains("yourlibrary") {
                NSLog("[Omneon] class: \(name)")
            }
        }
        
    }
}
