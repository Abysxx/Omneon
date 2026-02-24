import Orion
import UIKit

struct HideExplore: HookGroup {}

// Track the index path to hide
var hiddenIndexPath: IndexPath? = nil

class HideExplore_CollectionViewHook: ClassHook<UICollectionView> {
    typealias Group = HideExplore
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()

        let targetClass: AnyClass = NSClassFromString("WatchFeed_NPVProviderImpl.WatchFeedNPVView")!

        for cell in target.visibleCells {
            if cell.subviews.contains(where: { subview in
                subview.subviews.contains(where: { $0.isKind(of: targetClass) })
            }) {
                if let indexPath = target.indexPath(for: cell) {
                    // Only invalidate if the hidden path changed
                    if hiddenIndexPath != indexPath {
                        hiddenIndexPath = indexPath
                        target.collectionViewLayout.invalidateLayout()
                    }
                }
                cell.isHidden = true
                cell.isUserInteractionEnabled = false
                break
            }
        }
    }
}

class HideExplore_LayoutHook: ClassHook<UICollectionViewLayout> {
    typealias Group = HideExplore

    // Match the layout used by the target collection view
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollLayout"

    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var attrs = orig.layoutAttributesForElements(in: rect) else { return nil }

        if let hidden = hiddenIndexPath {
            attrs = attrs.map { attr in
                if attr.indexPath == hidden {
                    let zeroed = attr.copy() as! UICollectionViewLayoutAttributes
                    zeroed.frame = .zero
                    zeroed.isHidden = true
                    return zeroed
                }
                return attr
            }
        }
        return attrs
    }

    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attr = orig.layoutAttributesForItem(at: indexPath) else { return nil }

        if let hidden = hiddenIndexPath, indexPath == hidden {
            let zeroed = attr.copy() as! UICollectionViewLayoutAttributes
            zeroed.frame = .zero
            zeroed.isHidden = true
            return zeroed
        }
        return attr
    }
}
