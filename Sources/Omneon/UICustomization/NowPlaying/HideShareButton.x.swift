import Orion
import UIKit
import SwiftUI


struct HideShareButton: HookGroup { }

class NowPlaying_ModesImpl_FooterElementsUnit_Hook_2: ClassHook<UIViewController> {
    typealias Group = HideShareButton
    static let targetName = "NowPlaying_ModesImpl.FooterElementsUnit"
    
    private let hideIndex: Int = 4

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        guard let root = target.view, root.subviews.count > 1 else { return }
        let container = root.subviews[1]

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
