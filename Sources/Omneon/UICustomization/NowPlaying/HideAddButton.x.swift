import Orion
import UIKit
import SwiftUI

struct HideAddButton: HookGroup { }

class NowPlaying_ModesImpl_InformationElementsUnit_Hook_1: ClassHook<UIView> {
    typealias Group = HideAddButton
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        let root = target else { return }
        let subs = root.subviews
        guard subs.count > 1 else { return }

        let v = subs[1]

        if let stack = v as? UIStackView {
            if let first = stack.arrangedSubviews.first {
                stack.removeArrangedSubview(first)
                first.removeFromSuperview()
            }
        } else {
            v.isHidden = true
        }
    }
}
