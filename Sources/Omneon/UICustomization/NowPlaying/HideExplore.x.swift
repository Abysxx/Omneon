import Orion
import UIKit

struct HideExplore: HookGroup { }

class ScrollCollectionViewHook_0: ClassHook<UICollectionView> {
    typealias Group = HideExplore
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"
    
    private var hiddenIndexPaths = Set<IndexPath>()

    func layoutSubviews() {
        orig.layoutSubviews()

        let targetIdentifier = "Components.UI.ArtistBioCardNowPlayingView"

        for cell in target.visibleCells {
            guard let firstSubview = cell.subviews.first,
                  let secondSubview = firstSubview.subviews.first,
                  let thirdSubview = secondSubview.subviews.first else { continue }

            if thirdSubview.accessibilityIdentifier == targetIdentifier {
                cell.alpha = 0
                cell.isUserInteractionEnabled = false
                cell.isHidden = true
                cell.contentView.isHidden = true

                // Remember indexPath for layout adjustment
                if let indexPath = target.indexPath(for: cell) {
                    hiddenIndexPaths.insert(indexPath)
                }
            }
        }
        target.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Override layout attributes to hide cells fully
extension ScrollCollectionViewHook_0 {

    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attrs = orig.layoutAttributesForItem(at: indexPath) else { return nil }

        if hiddenIndexPaths.contains(indexPath) {
            attrs.size = .zero
            attrs.frame.size = .zero
            attrs.alpha = 0
            attrs.isHidden = true
        }

        return attrs
    }
}
