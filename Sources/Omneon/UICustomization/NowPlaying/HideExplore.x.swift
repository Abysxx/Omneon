import Orion
import UIKit

struct HideExplore: HookGroup { }

class ScrollCollectionViewHook_0: ClassHook<UICollectionView> {
    typealias Group = HideExplore
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()
        
        // Target class to check
        let targetClass: AnyClass = NSClassFromString("WatchFeed_NPVProviderImpl.WatchFeedNPVView")!
        
        for cell in target.visibleCells {
            // Look for subviews containing the target class
            if cell.subviews.contains(where: { subview in
                subview.subviews.contains(where: { $0.isKind(of: targetClass) })
            }) {
                // Hide the cell completely
                cell.alpha = 0
                cell.isHidden = true
                cell.isUserInteractionEnabled = false
                cell.contentView.isHidden = true

                // Force layout updates
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                
                // Adjust layout attributes
                if let indexPath = target.indexPath(for: cell),
                   let attributes = target.layoutAttributesForItem(at: indexPath) {
                    attributes.size = .zero
                    attributes.frame = .zero
                }
                
                break // only hide the first match
            }
        }
    }
}
