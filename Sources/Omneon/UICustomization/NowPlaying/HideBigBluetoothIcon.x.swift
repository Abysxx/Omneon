import Orion
import UIKit
import SwiftUI

struct HideBigBluetoothIcon: HookGroup { }

class NowPlaying_BarImpl_ContentViewControllerImplementation_Hook_3: ClassHook<UIViewController> {
    typealias Group = HideBigBluetoothIcon
    static let targetName = "NowPlaying_BarImpl.ContentViewControllerImplementation"
    
    private let hideIndex: Int = 0

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
      
        guard let root = target.view, root.subviews.count >= 5 else { return }
        let containerParent = root.subviews[5]
        let container = containerParent.subviews[0]

        guard let stack = container as? UIStackView else {
          //container.isHidden = true
          return
        }

        if stack.arrangedSubviews.count > hideIndex {
            let viewToHide = stack.arrangedSubviews[hideIndex]
            viewToHide.isHidden = true
        }
    }
}
