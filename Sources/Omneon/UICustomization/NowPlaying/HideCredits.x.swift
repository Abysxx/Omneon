import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

var hiddenIndexPath_2: IndexPath? = nil

class HideCredits_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        if containsIdentifier(cell, identifier: "TrackCredits.Card") {
            hiddenIndexPath_2 = indexPath
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HideCredits_EmptyCell")
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HideCredits_EmptyCell", for: indexPath)
        }
        return cell
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == hiddenIndexPath_2 {
            cell.isHidden = true
            cell.contentView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.isActive = false
                }
            }
            cell.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.isActive = false
                }
            }
            let zeroHeight = cell.heightAnchor.constraint(equalToConstant: 0)
            zeroHeight.priority = .required
            zeroHeight.isActive = true
            cell.layoutIfNeeded()
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var insets = orig.collectionView(collectionView, layout: layout, insetForSectionAt: section)
        NSLog("[Omneon] itemSize: \((layout as? UICollectionViewFlowLayout)?.itemSize ?? .zero)")
        NSLog("[Omneon] insets: \(insets)")
        if hiddenIndexPath_2 != nil {
            let itemSize = (layout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
            insets.bottom -= itemSize.height
        }
        return insets
    }
}
