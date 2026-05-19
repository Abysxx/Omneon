import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }
var localFilesItem: Int? = nil
var isScanning = false

func scanAndRemoveLocalFiles(in collectionView: UICollectionView) {
    guard !isScanning else { return }
    isScanning = true
    localFilesItem = nil
    for cell in collectionView.visibleCells {
        if containsIdentifier(cell, identifier: "LocalFiles.Row.Library"),
           let indexPath = collectionView.indexPath(for: cell) {
            localFilesItem = indexPath.item
            DispatchQueue.main.async {
                collectionView.reloadData()
                isScanning = false
            }
            return
        }
    }
    isScanning = false
}

class HideLocalFiles_ControllerHook: ClassHook<UIViewController> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)
        localFilesItem = nil
        isScanning = false
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
        return localFilesItem != nil ? count - 1 : count
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hidden = localFilesItem else {
            let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
            if containsIdentifier(cell, identifier: "LocalFiles.Row.Library") {
                localFilesItem = indexPath.item
                DispatchQueue.main.async { collectionView.reloadData() }
            }
            return cell
        }
        let adjusted = indexPath.item >= hidden
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        return orig.collectionView(collectionView, cellForItemAt: adjusted)
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if containsIdentifier(cell, identifier: "LocalFiles.Row.Library") {
            if localFilesItem != indexPath.item {
                localFilesItem = indexPath.item
                DispatchQueue.main.async { collectionView.reloadData() }
            }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    @objc(collectionView:didSelectItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hidden = localFilesItem else {
            orig.collectionView(collectionView, didSelectItemAt: indexPath)
            return
        }
        let adjusted = indexPath.item >= hidden
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        orig.collectionView(collectionView, didSelectItemAt: adjusted)
    }
}
