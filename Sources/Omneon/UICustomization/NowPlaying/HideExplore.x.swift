import Orion
import UIKit

struct HideExplore: HookGroup { }

class ScrollCollectionViewHook_0: ClassHook<UICollectionView> {
    typealias Group = HideExplore
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()

        let targetIdentifier = "Components.UI.ArtistBioCardNowPlayingView"

        var indexPathsToDelete: [IndexPath] = []

        for cell in target.visibleCells {
            guard let first = cell.subviews.first,
                  let second = first.subviews.first,
                  let third = second.subviews.first else { continue }

            if third.accessibilityIdentifier == targetIdentifier {
                cell.isHidden = true
                cell.alpha = 0
                cell.isUserInteractionEnabled = false
                cell.contentView.isHidden = true
                if let indexPath = target.indexPath(for: cell) {
                    indexPathsToDelete.append(indexPath)
                }
            }
        }
        if !indexPathsToDelete.isEmpty {
            target.performBatchUpdates({
                for indexPath in indexPathsToDelete {
                    target.deleteItems(at: [indexPath])
                    if let collectionData = target.value(forKey: "UICollectionViewData") as? NSObject {
                        let totalCountKey = "_totalItemCount"
                        if let current = collectionData.value(forKey: totalCountKey) as? Int {
                            collectionData.setValue(current - 1, forKey: totalCountKey)
                        }
                    }
                }
            }, completion: nil)
        }
        target.collectionViewLayout.invalidateLayout()
    }
}
