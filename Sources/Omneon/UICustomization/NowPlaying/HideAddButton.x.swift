import Orion
import UIKit
import SwiftUI

struct HideAddButton: HookGroup { }

class NowPlaying_ModesImpl_InformationElementsUnit_Hook_2: ClassHook<UIViewController> {
    typealias Group = HideAddButton
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"
    private let removeIndex: Int = 1

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        guard let root = target.view, root.subviews.count > 1 else { return }
        let v = root.subviews[1]

        guard let stack = v as? UIStackView else {
            v.isHidden = true
            return
        }

        for (i, arranged) in stack.arrangedSubviews.enumerated() {
            if i == removeIndex {
                stack.removeArrangedSubview(arranged)
                arranged.removeFromSuperview()
                break
            }
        }
    }
}
