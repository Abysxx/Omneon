import Orion
import UIKit

struct HideExplore: HookGroup { }

class ScrollCollectionViewHook_0: ClassHook<UICollectionView> {
    typealias Group = HideExplore
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        
        orig.layoutSubviews()
        
        let targetIdentifier = "Components.UI.ArtistBioCardNowPlayingView"
        
        for cell in target.visibleCells {
            if cell.subviews[0].subviews[0].subviews[0].accessibilityIdentifier == targetIdentifier {
                // Hide the cell
                cell.isHidden = true
                cell.alpha = 0
                cell.isUserInteractionEnabled = false
                cell.contentView.isHidden = true
                
                // Force UICollectionView to treat it as zero size
                if let indexPath = target.indexPath(for: cell),
                   let layout = target.collectionViewLayout as? UICollectionViewFlowLayout {
                    
                    // Use invalidation to force the layout to recalc
                    layout.invalidateLayout(with: UICollectionViewFlowLayoutInvalidationContext())
                    
                    // Optional: if using iOS 14+ self-sizing cells
                    target.performBatchUpdates({
                        target.reloadItems(at: [indexPath])
                    }, completion: nil)
                }
            }
        }
    }
}
