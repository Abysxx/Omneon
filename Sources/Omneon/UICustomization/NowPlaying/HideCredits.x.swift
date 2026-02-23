import Orion
import UIKit

struct HideCredits: HookGroup { }

class ScrollCollectionViewHook_2: ClassHook<UICollectionView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()

        let targetIdentifier = "scrolling_npv_collection_view_cell_accessibility_identifier_2"

        for cell in target.visibleCells {
            if cell.accessibilityIdentifier == targetIdentifier {
                NSLog("[Fire] Found target cell, hiding it.")
                cell.isHidden = true
                
                // If you prefer full removal instead:
                // if let indexPath = target.indexPath(for: cell) {
                //     target.deleteItems(at: [indexPath])
                // }
            }
        }
    }
}
