import Orion
import UIKit
import Foundation

struct HideAboutArtist: HookGroup {}

// Track the index path to hide
var hiddenIndexPath: IndexPath? = nil

class HideAboutArtist_CollectionViewHook: ClassHook<UICollectionView> {
    typealias Group = HideAboutArtist
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()

        for cell in target.visibleCells {
            if cell.subviews.contains(where: { subview in
                subview.subviews.contains(where: { $0.accessibilityIdentifier == "Components.UI.ArtistBioCardNowPlayingView"})
            }) {
                if let indexPath = target.indexPath(for: cell) {
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

class HideAboutArtist_LayoutHook: ClassHook<UICollectionViewLayout> {
    typealias Group = HideAboutArtist

    // Match the layout used by the target collection view
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollLayout"

    @objc(layoutAttributesForElementsInRect:)
    func layoutAttributesForElements(in rect: CGRect) -> NSArray? {
        guard var attrs = orig.layoutAttributesForElements(in: rect) as? [UICollectionViewLayoutAttributes] else { return nil }
        NSLog("[Omneon] \(hiddenIndexPath)")
        if let hidden = hiddenIndexPath {
            attrs = attrs.map { attr in
                // Only target cells, not headers/footers/decorations
                if attr.representedElementCategory == .cell && attr.indexPath == hidden {
                    let zeroed = attr.copy() as! UICollectionViewLayoutAttributes
                    zeroed.frame = .zero
                    zeroed.isHidden = true
                    return zeroed
                }
                return attr
            }
        }
        return attrs as NSArray
    }

    @objc(layoutAttributesForItemAtIndexPath:)
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
