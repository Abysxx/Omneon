import Orion
import UIKit

struct HideCredits: HookGroup { }

class ScrollCollectionViewHook: ClassHook<UICollectionView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()

        // So apparently this changes and isn't the same everytime smh
        //let targetIdentifier = "scrolling_npv_collection_view_cell_accessibility_identifier_2"
        let targetIdentifier = "TrackCredits.Card"
    
        for cell in target.visibleCells {
            // Probably unstable
            if cell.subviews[0].subviews[0].accessibilityIdentifier == targetIdentifier {
                cell.alpha = 0
                cell.isUserInteractionEnabled = false
                if let indexPath = target.indexPath(for: cell),
                   let attributes = target.layoutAttributesForItem(at: indexPath) {

                    attributes.size = .zero
                    attributes.frame.size = .zero
                }
            }
        }
    }
}
