import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }
var localFilesIndexPath: IndexPath? = nil

class HideLocalFiles_DataSourceHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryContentViewBinder"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        // scan all items to find localFiles index
        for i in 0..<count {
            let ip = IndexPath(item: i, section: section)
            let cell = orig.collectionView(collectionView, cellForItemAt: ip)
            if cell.reuseIdentifier == "YourLibraryListItemBinderIdentifier.localFilesRow.none" {
                localFilesIndexPath = ip
                break
            }
        }
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

class HideLocalFiles_ViewControllerHook: ClassHook<UIViewController> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        localFilesIndexPath = nil
    }
}
