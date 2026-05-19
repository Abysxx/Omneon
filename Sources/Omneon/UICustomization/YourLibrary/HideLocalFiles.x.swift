import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }
var localFilesIndexPath: IndexPath? = nil

class YourLibraryCollectionView_Hook: ClassHook<UICollectionView> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_CommonKit.YourLibraryCollectionView"

    func layoutSubviews() {
        orig.layoutSubviews()
        for cell in target.visibleCells {
            if cell.reuseIdentifier == "YourLibraryListItemBinderIdentifier.localFilesRow.none",
               let indexPath = target.indexPath(for: cell) {
                if localFilesIndexPath != indexPath {
                    localFilesIndexPath = indexPath
                    target.performBatchUpdates {
                        target.deleteItems(at: [indexPath])
                    }
                }
                break
            }
        }
    }
}

class HideLocalFiles_DataSourceHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryContentViewBinder"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        return localFilesIndexPath != nil ? count - 1 : count
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hidden = localFilesIndexPath else {
            return orig.collectionView(collectionView, cellForItemAt: indexPath)
        }
        let adjusted = indexPath.item >= hidden.item
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        return orig.collectionView(collectionView, cellForItemAt: adjusted)
    }
}
