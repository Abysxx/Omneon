import Orion
import UIKit
import SwiftUI

struct HideBanButton: HookGroup { }

class NowPlaying_ModesImpl_InformationElementsUnit_Hook_2: ClassHook<UIView> {
    typealias Group = HideAddButton
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        let root = target else { return }
        let subs = root.subviews
        guard subs.count > 1 else { return }

        let v = subs[1]

        if let stack = v as? UIStackView {
            if stack.arrangedSubviews.count > 1 {
                let second = stack.arrangedSubviews[1]
                stack.removeArrangedSubview(second)
                second.removeFromSuperview()
            }
        } else {
            v.isHidden = true
        }
    }
}
