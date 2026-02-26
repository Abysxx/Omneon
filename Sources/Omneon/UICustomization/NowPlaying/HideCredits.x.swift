import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

class HideCredits_CellHook: ClassHook<UIView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollCellWithDynamicSizing"
    
    @objc(systemLayoutSizeFittingSize:)
    func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        if containsIdentifier(target, identifier: "TrackCredits.Card") {
            return .zero
        }
        return orig.systemLayoutSizeFitting(targetSize)
    }
    
    @objc(systemLayoutSizeFittingSize:withHorizontalFittingPriority:verticalFittingPriority:)
    func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        if containsIdentifier(target, identifier: "TrackCredits.Card") {
            return .zero
        }
        return orig.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}
