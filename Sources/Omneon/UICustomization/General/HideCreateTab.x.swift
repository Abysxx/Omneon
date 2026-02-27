import Orion
import UIKit
import SwiftUI

struct HideCreateTab: HookGroup { }

class SPTAdaptiveTabBarController_Hook_1: ClassHook<UITabBarController> {
    typealias Group = HideCreateTab
    static let targetName = "SPTAdaptiveTabBarController"
  
    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        guard let root = target.view, root.subviews.count > 1 else { return }
        if let tabBar = root.subviews[1] as? UITabBar {
            tabBar.items = tabBar.items?.filter { $0.title != "Create" }
        }
    }
}
