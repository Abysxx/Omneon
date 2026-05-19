import Orion
import UIKit
import Foundation

struct HideLocalFiles: HookGroup {}]

func containsIdentifier1(_ view: UIView, identifier: String) -> Bool {
    if view.accessibilityIdentifier == identifier || 
       String(describing: type(of: view)).contains(identifier) ||
       view.restorationIdentifier == identifier {
        return true
    }
    for subview in view.subviews {
        if containsIdentifier1(subview, identifier: identifier) {
            return true
        }
    }
    return false
}

class HideLocalFiles_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_CommonKit.YourLibraryCollectionView"

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        
        if containsIdentifier1(cell, identifier: "LocalFiles.Row.Library") {
            cell.isHidden = true
            cell.alpha = 0
            cell.isUserInteractionEnabled = false
            
            var frame = cell.frame
            frame.size.height = 0
            frame.size.width = 0
            cell.frame = frame
        } else {
            cell.isHidden = false
            cell.alpha = 1
            cell.isUserInteractionEnabled = true
        }
        
        return cell
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        
        if containsIdentifier1(cell, identifier: "LocalFiles.Row.Library") {
            cell.isHidden = true
            cell.alpha = 0
            cell.isUserInteractionEnabled = false
        }
    }
}
