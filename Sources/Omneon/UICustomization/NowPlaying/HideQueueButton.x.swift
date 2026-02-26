import Orion
import UIKit
import SwiftUI


struct HideQueueButton: HookGroup { }

class NowPlaying_ModesImpl_FooterElementsUnit_Hook_3: ClassHook<UIViewController> {
    typealias Group = HideBluetoothButton
    static let targetName = "NowPlaying_ModesImpl.FooterElementsUnit"
    
    private let hideIndex: Int = 5

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
      
        guard let root = target.view
        let container = root.subviews[0]

        guard let stack = container as? UIStackView else {
            container.alpha = 0
            return
        }

        if stack.arrangedSubviews.count > hideIndex {
            let viewToHide = stack.arrangedSubviews[hideIndex]
            viewToHide.alpha = 0
        }
    }
}
