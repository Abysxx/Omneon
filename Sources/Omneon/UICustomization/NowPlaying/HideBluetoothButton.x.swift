import Orion
import UIKit
import SwiftUI


struct HideBluetoothButton: HookGroup { }

class NowPlaying_ModesImpl_FooterElementsUnit_Hook_1: ClassHook<UIViewController> {
    typealias Group = HideBluetoothButton
    static let targetName = "NowPlaying_ModesImpl.FooterElementsUnit"
    
    private let hideIndex: Int = 0

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        // I think this still works works?
        guard let root = target.view, root.subviews.count > 1 else { return }
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
