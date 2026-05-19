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
        return localFilesIndexPath != nil ? count - 1 : count
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        if cell.reuseIdentifier == "YourLibraryListItemBinderIdentifier.localFilesRow.none" {
            localFilesIndexPath = indexPath
            DispatchQueue.main.async { collectionView.reloadData() }
        }
        return cell
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.reuseIdentifier == "YourLibraryListItemBinderIdentifier.localFilesRow.none" {
            if localFilesIndexPath != indexPath {
                localFilesIndexPath = indexPath
                DispatchQueue.main.async { collectionView.reloadData() }
            }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
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
