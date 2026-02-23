import Orion
import UIKit
import SwiftUI

struct HideAddButton: HookGroup { }

class NowPlaying_ModesImpl_InformationElementsUnit_Hook_2: ClassHook<UIViewController> {
    typealias Group = HideAddButton
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        let root = target.view

        guard let root = root, root.subviews.count > 1 else { return }

        let v = root.subviews[1]

        guard let stack = v as? UIStackView else {
            v.isHidden = true
            return
        }

        if stack.arrangedSubviews.count > 1 {
            let second = stack.arrangedSubviews[1]
            stack.removeArrangedSubview(second)
            second.removeFromSuperview()
        }
    }
}
