import Orion
import UIKit

struct HideCredits: HookGroup { }

class ScrollCollectionViewHook: ClassHook<UICollectionView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()

        let targetIdentifier = "scrolling_npv_collection_view_cell_accessibility_identifier_2"

        for cell in target.visibleCells {
            if cell.accessibilityIdentifier == targetIdentifier {
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
