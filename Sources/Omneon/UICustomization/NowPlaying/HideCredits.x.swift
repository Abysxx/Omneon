import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

class HideCredits_CellHook: ClassHook<UIView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollCellWithDynamicSizing"
    
    func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        if containsIdentifier(target, identifier: "TrackCredits.Card") {
            return .zero
        }
        return orig.systemLayoutSizeFitting(targetSize)
    }
    
    func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        if containsIdentifier(target, identifier: "TrackCredits.Card") {
            return .zero
        }
        return orig.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}
