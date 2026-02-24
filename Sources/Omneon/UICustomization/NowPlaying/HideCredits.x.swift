import Orion
import UIKit

struct HideCredits: HookGroup { }

class NowPlayingScrollLayoutHook: ClassHook<UICollectionViewLayout> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollLayout"

    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = orig.layoutAttributesForElements(in: rect) else {
            return nil
        }

        for attr in attributes {
            if let collectionView = target.collectionView,
               let cell = collectionView.cellForItem(at: attr.indexPath),
               cell.accessibilityIdentifier == "scrolling_npv_collection_view_cell_accessibility_identifier_2" {

                attr.size = .zero
                attr.frame.size = .zero
            }
        }

        return attributes
    }
}
