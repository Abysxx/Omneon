import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

// Track the index path to hide
var hiddenIndexPath_2: IndexPath? = nil

class HideCredits_CollectionViewHook: ClassHook<UICollectionView> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()

        for cell in target.visibleCells {
            if cell.subviews.contains(where: { subview in
                subview.subviews.contains(where: { $0.accessibilityIdentifier == "TrackCredits.Card" })
            }) {
                if let indexPath = target.indexPath(for: cell) {
                    if hiddenIndexPath_2 != indexPath {
                        hiddenIndexPath_2 = indexPath
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

class HideCredits_LayoutHook: ClassHook<UICollectionViewLayout> {
    typealias Group = HideCredits

    // Match the layout used by the target collection view
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollLayout"

    @objc(layoutAttributesForElementsInRect:)
    func layoutAttributesForElements(in rect: CGRect) -> NSArray? {
        guard var attrs = orig.layoutAttributesForElements(in: rect) as? [UICollectionViewLayoutAttributes] else { return nil }
        if let hidden = hiddenIndexPath_2 {
            NSLog("[Omneon] hiddenIndexPath: \(hidden)")
            attrs = attrs.map { attr in
                // Only target cells, not headers/footers/decorations
                if attr.representedElementCategory == .cell {
                    NSLog("[Omneon] cell attr indexPath: \(attr.indexPath) frame: \(attr.frame)")
                }
                if attr.representedElementCategory == .cell && attr.indexPath == hidden {
                    NSLog("[Omneon] ZEROING [0,3]")
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

    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == hiddenIndexPath_2 {
            NSLog("[Omneon] CollectionView Attempt")
            return .zero
        }
        return orig.collectionView(collectionView, layout: layout, sizeForItemAt: indexPath)
    }

    @objc(layoutAttributesForItemAtIndexPath:)
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attr = orig.layoutAttributesForItem(at: indexPath) else { return nil }

        if let hidden = hiddenIndexPath_2, indexPath == hidden {
            let zeroed = attr.copy() as! UICollectionViewLayoutAttributes
            zeroed.frame = .zero
            zeroed.isHidden = true
            return zeroed
        }
        return attr
    }
}
