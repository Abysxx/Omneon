import Orion
import UIKit
import SwiftUI

struct HideAddButton: HookGroup { }

class NowPlaying_ModesImpl_InformationElementsUnit_Hook_2: ClassHook<UIViewController> {
    typealias Group = HideAddButton
    static let targetName = "NowPlaying_ModesImpl.InformationElementsUnit"
    
    private let hideIndex: Int = 1

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        guard let root = target.view, root.subviews.count > 1 else { return }
        let container = root.subviews[1]

        guard let stack = container as? UIStackView else {
            container.isHidden = true
            return
        }

        if stack.arrangedSubviews.count > hideIndex {
            let viewToHide = stack.arrangedSubviews[hideIndex]
            viewToHide.isHidden = true
        }
    }
}
