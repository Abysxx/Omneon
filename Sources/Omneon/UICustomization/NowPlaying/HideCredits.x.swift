import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

class HideCredits_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        if findAccessibilityIdentifier(cell, identifier: "TrackCredits.Card") {
            HideCreditsState.hiddenIndexPath = indexPath
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HideCredits_EmptyCell")
            return collectionView.dequeueReusableCell(withReuseIdentifier: "HideCredits_EmptyCell", for: indexPath)
        }
        return cell
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == HideCreditsState.hiddenIndexPath {
            cell.frame = .zero
            cell.isHidden = true
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
