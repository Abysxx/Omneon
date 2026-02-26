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
        NSLog("[Omneon] SubviewCount: \(target.view.subviews.count)")
        guard let root = target.view, root.subviews.count > 1 else { return }
        let container = root.subviews[0]
        NSLog("[Omneon]1 Container: \(container)")
        guard let stack = container as? UIStackView else {
            NSLog("[Omneon]1 Setting Container.aplha=0")
            container.alpha = 0
            return
        }

        if stack.arrangedSubviews.count > hideIndex {
            NSLog("[Omneon]1 Setting viewToHide.aplha=0")
            let viewToHide = stack.arrangedSubviews[hideIndex]
            NSLog("[Omneon]1 ViewToHide: \(viewToHide)")
            viewToHide.alpha = 0
        }
    }
}
