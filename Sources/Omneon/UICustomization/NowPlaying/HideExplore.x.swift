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
                if let indexPath = target.indexPath(for: cell) {
                    target.performBatchUpdates({
                        target.deleteItems(at: [indexPath])
                    }, completion: nil)
                }
            }
        }
    }
}
