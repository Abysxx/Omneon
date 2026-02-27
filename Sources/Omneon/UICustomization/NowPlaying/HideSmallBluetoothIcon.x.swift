import Orion
import UIKit
import SwiftUI

struct HideSmallBluetoothIcon: HookGroup { }

class NowPlaying_BarImpl_ContentViewControllerImplementation_Hook_1: ClassHook<UIViewController> {
    typealias Group = HideSmallBluetoothIcon
    static let targetName = "NowPlaying_BarImpl.ContentViewControllerImplementation"
    
    private let hideIndex: Int = 2

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
      
        guard let root = target.view, root.subviews.count >= 5 else { return }
        let viewToHide = root.subviews[hideIndex]
        viewToHide.isHidden = true
    }
}
