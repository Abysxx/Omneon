import Orion
import UIKit
import SwiftUI

struct HideBanButton: HookGroup { }

class NowPlaying_ModesImpl_InformationElementsUnit_Hook_1: ClassHook<UIViewController> {
    typealias Group = HideBanButton
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"
    private let removeIndex: Int = 0

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        guard let root = target.view, root.subviews.count > 1 else { return }
        let v = root.subviews[1]

        guard let stack = v as? UIStackView else {
            v.isHidden = true
            return
        }
        let arrangedCopy = stack.arrangedSubviews

        if arrangedCopy.count > removeIndex {
            let toRemove = arrangedCopy[removeIndex]
            stack.removeArrangedSubview(toRemove)
            toRemove.removeFromSuperview()
        }
    }
}
