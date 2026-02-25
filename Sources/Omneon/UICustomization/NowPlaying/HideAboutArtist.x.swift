import Orion
import UIKit
import Foundation

struct HideAboutArtist: HookGroup {}

// Track the index path to hide
var hiddenIndexPath_3: IndexPath? = nil

func containsIdentifier(_ view: UIView, identifier: String) -> Bool {
    if view.accessibilityIdentifier == identifier {
        return true
    }
    for subview in view.subviews {
        if containsIdentifier(subview, identifier: identifier) {
            return true
        }
    }
    return false
}

class HideAboutArtist_CollectionViewHook: ClassHook<UICollectionView> {
    typealias Group = HideAboutArtist
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewWithDynamicSizing"

    
    
    func layoutSubviews() {
        orig.layoutSubviews()
        
            if containsIdentifier(cell, identifier: "Components.UI.ArtistBioCardNowPlayingView") {
            NSLog("[Omneon](1) Found accessibilityIdentifier")
            if let indexPath = target.indexPath(for: cell) {
                NSLog("[Omneon](2) \(indexPath)")
                    if hiddenIndexPath_3 != indexPath {
                        hiddenIndexPath_3 = indexPath
                        target.collectionViewLayout.invalidateLayout()
                    }
                }
                cell.isHidden = true
                cell.isUserInteractionEnabled = false
                
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
        if let hidden = hiddenIndexPath_3 {
            NSLog("[Omneon](3) \(hiddenIndexPath_3)")
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

        if let hidden = hiddenIndexPath_3, indexPath == hidden {
            let zeroed = attr.copy() as! UICollectionViewLayoutAttributes
            zeroed.frame = .zero
            zeroed.isHidden = true
            return zeroed
        }
        return attr
    }
}
