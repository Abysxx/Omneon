import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }
var localFilesIndexPath: IndexPath? = nil

func scanAndRemoveLocalFiles(in collectionView: UICollectionView) {
    for cell in collectionView.visibleCells {
        if containsIdentifier(cell, identifier: "LocalFiles.Row.Library"),
           let indexPath = collectionView.indexPath(for: cell) {
            if localFilesIndexPath != indexPath {
                localFilesIndexPath = indexPath
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            break
        }
    }
}

class HideLocalFiles_ControllerHook: ClassHook<UIViewController> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        localFilesIndexPath = nil
    }

    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        let view = self.target.view
        guard
            let s0 = view?.subviews[safe: 0],
            let s1 = s0.subviews[safe: 0],
            let s2 = s1.subviews[safe: 0],
            let s3 = s2.subviews[safe: 0],
            let collectionView = s3.subviews[safe: 0] as? UICollectionView
        else { return }
        scanAndRemoveLocalFiles(in: collectionView)
    }
}

class HideLocalFiles_DelegateHook: ClassHook<NSObject> {
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
            let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
            if containsIdentifier(cell, identifier: "LocalFiles.Row.Library") {
                localFilesIndexPath = indexPath
                DispatchQueue.main.async { collectionView.reloadData() }
            }
            return cell
        }
        let adjusted = indexPath.item >= hidden.item
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        return orig.collectionView(collectionView, cellForItemAt: adjusted)
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if containsIdentifier(cell, identifier: "LocalFiles.Row.Library") && localFilesIndexPath != indexPath {
            localFilesIndexPath = indexPath
            DispatchQueue.main.async { collectionView.reloadData() }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
