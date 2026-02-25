import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

var hiddenIndexPath_2: IndexPath? = nil
var hiddenCellHeight_2: CGFloat = 0

class HideCredits_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        if containsIdentifier(cell, identifier: "TrackCredits.Card") {
            hiddenIndexPath_2 = indexPath
            hiddenCellHeight_2 = cell.bounds.height
            NSLog("[Omneon] hiddenCellHeight: \(cell.bounds.height)")
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HideCredits_EmptyCell")
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HideCredits_EmptyCell", for: indexPath)
        }
        return cell
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == hiddenIndexPath_2 {
            cell.isHidden = true
            cell.contentView.constraints.forEach { $0.isActive = $0.firstAttribute != .height }
            cell.constraints.forEach { $0.isActive = $0.firstAttribute != .height }
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
        if hiddenIndexPath_2 != nil && hiddenCellHeight_2 > 0 {
            insets.bottom -= hiddenCellHeight_2
        }
        return insets
    }
}
