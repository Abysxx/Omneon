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
        // Overwrite the original registration once
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TRACK_CREDITS")
        
        if indexPath == hiddenIndexPath_2 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "TRACK_CREDITS", for: indexPath)
        }
        
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        if containsIdentifier(cell, identifier: "TrackCredits.Card") {
            hiddenIndexPath_2 = indexPath
            return collectionView.dequeueReusableCell(withReuseIdentifier: "TRACK_CREDITS", for: indexPath)
        }
        return cell
    }
    
    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == hiddenIndexPath_2 {
            cell.layoutIfNeeded()
            hiddenCellHeight_2 = cell.bounds.height
            NSLog("[Omneon] Cell Height: \(cell.bounds.height)")
            cell.isHidden = true
    
            // Remove any previously added zero height constraints to avoid duplicates
            cell.constraints.filter { $0.identifier == "HideCredits_ZeroHeight" }.forEach { $0.isActive = false }
            cell.contentView.constraints.forEach { $0.isActive = $0.firstAttribute != .height }
            cell.constraints.forEach { $0.isActive = $0.firstAttribute != .height }
    
            let zeroHeight = cell.heightAnchor.constraint(equalToConstant: 100)
            zeroHeight.priority = .required
            zeroHeight.identifier = "HideCredits_ZeroHeight"
            zeroHeight.isActive = true
            cell.layoutIfNeeded()
    
            // Invalidate layout to pick up correct height
            DispatchQueue.main.async {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var insets = orig.collectionView(collectionView, layout: layout, insetForSectionAt: section)
        if hiddenIndexPath_2 != nil && hiddenCellHeight_2 > 0 {
            insets.bottom -= (hiddenCellHeight_2 - 100)
        }
        return insets
    }
}
