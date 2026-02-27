import Orion
import UIKit
import SwiftUI

struct HideCreateTab: HookGroup { }

class SPTAdaptiveTabBarController_Hook_1: ClassHook<UITabBarController> {
    typealias Group = HideCreateTab
    static let targetName = "SPTAdaptiveTabBarController"
  
    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        target.viewControllers = target.viewControllers?.filter { $0.tabBarItem.title?.lowercased() != "create" }
    }
}
