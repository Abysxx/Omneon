import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

var hiddenIndexPath_2: IndexPath? = nil

class HideCredits_ViewControllerHook: ClassHook<UIViewController> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollViewController"

    func viewDidLoad() {
        orig.viewDidLoad()
        
        var output = "=== NowPlayingScrollViewController Dump ===\n"
        
        var cls: AnyClass? = NSClassFromString("NowPlaying_ScrollImpl.NowPlayingScrollViewController")
        while let current = cls {
            output += "\n--- \(NSStringFromClass(current)) ---\n"
            
            var methodCount: UInt32 = 0
            if let methods = class_copyMethodList(current, &methodCount) {
                for i in 0..<Int(methodCount) {
                    output += "  METHOD: \(NSStringFromSelector(method_getName(methods[i])))\n"
                }
                free(methods)
            }
            
            var ivarCount: UInt32 = 0
            if let ivars = class_copyIvarList(current, &ivarCount) {
                for i in 0..<Int(ivarCount) {
                    let name = String(cString: ivar_getName(ivars[i])!)
                    output += "  IVAR: \(name)\n"
                }
                free(ivars)
            }
            
            cls = class_getSuperclass(current)
        }
        
        output += "\n=== End Dump ==="
        
        let path = "/var/mobile/Documents/omneon_dump.txt"
        try? output.write(toFile: path, atomically: true, encoding: .utf8)
        NSLog("[Omneon] Dump written to \(path)")
    }
}
