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
            // Probably unstable
            if cell.subviews[0].subviews[0].subviews[0].accessibilityIdentifier == targetIdentifier {
                cell.alpha = 0
                cell.isUserInteractionEnabled = false
                cell.isHidden = true
                cell.contentView.isHidden = true
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                if let indexPath = target.indexPath(for: cell), let attributes = target.layoutAttributesForItem(at: indexPath) { 
                    attributes.size = .zero
                    attributes.frame.size = .zero
                }
            }
        }
    }
    
    func insertItems(at indexPaths: [IndexPath]) {
        orig.insertItems(at: indexPaths)
        NSLog("[Omneon] reloadItems: \(indexPaths)")
    }
}
