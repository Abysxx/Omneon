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
            cell.frame = .zero
            cell.isHidden = true
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
