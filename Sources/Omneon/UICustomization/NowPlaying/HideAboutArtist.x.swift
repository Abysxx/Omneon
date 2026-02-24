import Orion
import UIKit
import Foundation

struct HideAboutArtist: HookGroup {}

// Track the index path to hide
var hiddenIndexPath_3: IndexPath? = nil

class HideAboutArtist_CollectionViewHook: ClassHook<UICollectionView> {
    typealias Group = HideAboutArtist
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    func layoutSubviews() {
        orig.layoutSubviews()
        
        // Such a long name bruh
        let targetClass: AnyClass = NSClassFromString("_TtC14Creator_ECMKitP33_9A9A9C9886A2DEDE51521D11F82E7F9026CreatorBiographyCardLayout")!

        for cell in target.visibleCells {
            if cell.subviews.contains(where: { subview in
                subview.subviews.contains(where: { $0.isKind(of: targetClass) })
            }) {
                if let indexPath = target.indexPath(for: cell) {
                    // Only invalidate if the hidden path changed
                    if hiddenIndexPath_1 != indexPath {
                        hiddenIndexPath_1 = indexPath
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
        NSLog("[Omneon] \(hiddenIndexPath_3)")
        if let hidden = hiddenIndexPath_3 {
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
