import Orion
import UIKit
import SwiftUI

struct HideBanButton: HookGroup { }

class NowPlaying_ModesImpl_InformationElementsUnit_Hook_1: ClassHook<UIViewController> {
    typealias Group = HideBanButton
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        guard let root = target.view, root.subviews.count > 1 else { return }

        let v = root.subviews[1]

        guard let stack = v as? UIStackView else {
            v.isHidden = true
            NSLog("[Fire] Expected UIStackView but got \(type(of: v)). Hidden instead.")
            return
        }

        if stack.arrangedSubviews.count > 0 {
            let first = stack.arrangedSubviews[0]
            stack.removeArrangedSubview(first)
            first.removeFromSuperview()
            NSLog("[Fire] Removed first arrangedSubview safely.")
        }
    }
}
