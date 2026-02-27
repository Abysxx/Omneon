import Orion
import UIKit
import SwiftUI

struct MakeTabBarNotTransparent: HookGroup { }

class SPTAdaptiveTabBarController_Hook_2: ClassHook<UITabBarController> {
    typealias Group = MakeTabBarNotTransparent
    static let targetName = "SPTAdaptiveTabBarController"
  
    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        target.tabBar.backgroundColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1.0)
    }
}
