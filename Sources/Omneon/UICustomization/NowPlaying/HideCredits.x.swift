import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

class HideCredits_CellHook: ClassHook<UIView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollCellWithDynamicSizing"
    
    func didMoveToSuperview() {
        orig.didMoveToSuperview()
        if containsIdentifier(target, identifier: "TrackCredits.Card") {
            target.isHidden = true
            target.frame = .zero
            // Also constrain height to 0
            target.constraints.filter { $0.firstAttribute == .height }.forEach { $0.isActive = false }
            let zero = target.heightAnchor.constraint(equalToConstant: 0)
            zero.priority = .required
            zero.isActive = true
        }
    }
}
