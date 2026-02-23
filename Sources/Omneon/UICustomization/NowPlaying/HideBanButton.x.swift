import Orion
import UIKit
import SwiftUI

struct HideBanButton: HookGroup { }

class NowPlaying_ModesImpl_InformationElementsUnit_Hook_1: ClassHook<UIView> {
    typealias Group = HideBanButton
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"

    func viewDidLayoutSubviews() {

        orig.viewDidLayoutSubviews()

        let root = target

        guard root.subviews.count > 1 else { return }

        let v = root.subviews[1]

        guard let stack = v as? UIStackView else {
            v.isHidden = true
            return
        }

        if stack.arrangedSubviews.count > 0 {
            let first = stack.arrangedSubviews[0]
            stack.removeArrangedSubview(first)
            first.removeFromSuperview()

        }
    }
}
