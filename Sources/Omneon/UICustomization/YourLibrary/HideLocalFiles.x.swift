import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }
var hiddenLocalFilesIndexPath: IndexPath? = nil

func scanAndHideLocalFiles(in collectionView: UICollectionView) {
    for cell in collectionView.visibleCells {
        if let view = cell.subviews[safe: 2]?.subviews[safe: 0]?.subviews[safe: 0],
           view.accessibilityIdentifier == "LocalFiles.Row.Library",
           let indexPath = collectionView.indexPath(for: cell) {
            if hiddenLocalFilesIndexPath != indexPath {
                hiddenLocalFilesIndexPath = indexPath
                DispatchQueue.main.async { collectionView.reloadData() }
            }
            break
        }
    }
}

class HideLocalFiles_ViewControllerHook: ClassHook<UIViewController> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        guard let collectionView = target.view
            .subviews[safe: 0]?
            .subviews[safe: 0]?
            .subviews[safe: 0] as? UICollectionView else { return }
        hiddenLocalFilesIndexPath = nil
        scanAndHideLocalFiles(in: collectionView)
    }
}

class HideLocalFiles_DataSourceHook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryContentViewBinder"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        return hiddenLocalFilesIndexPath != nil ? count - 1 : count
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // always request one extra to account for hidden cell
        guard let hidden = hiddenLocalFilesIndexPath else {
            let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
            if let view = cell.subviews[safe: 2]?.subviews[safe: 0]?.subviews[safe: 0],
               view.accessibilityIdentifier == "LocalFiles.Row.Library" {
                hiddenLocalFilesIndexPath = indexPath
                DispatchQueue.main.async { collectionView.reloadData() }
            }
            return cell
        }
        if indexPath == hidden {
            // return a blank invisible cell instead
            return orig.collectionView(collectionView, cellForItemAt: IndexPath(item: hidden.item + 1, section: hidden.section))
        }
        let adjusted = indexPath.item >= hidden.item
            ? IndexPath(item: indexPath.item + 1, section: indexPath.section)
            : indexPath
        return orig.collectionView(collectionView, cellForItemAt: adjusted)
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        NSLog("[Omneon] cell at \(indexPath) subviews: \(cell.subviews.count)")
        for (i, sub) in cell.subviews.enumerated() {
            NSLog("[Omneon] cell.subviews[\(i)] = \(type(of: sub)) id=\(sub.accessibilityIdentifier ?? "nil") subviews=\(sub.subviews.count)")
            for (j, sub2) in sub.subviews.enumerated() {
                NSLog("[Omneon] cell.subviews[\(i)][\(j)] = \(type(of: sub2)) id=\(sub2.accessibilityIdentifier ?? "nil") subviews=\(sub2.subviews.count)")
                for (k, sub3) in sub2.subviews.enumerated() {
                    NSLog("[Omneon] cell.subviews[\(i)][\(j)][\(k)] = \(type(of: sub3)) id=\(sub3.accessibilityIdentifier ?? "nil")")
                }
            }
        }
        if hiddenLocalFilesIndexPath == nil,
           let view = cell.subviews[safe: 2]?.subviews[safe: 0]?.subviews[safe: 0],
           view.accessibilityIdentifier == "LocalFiles.Row.Library" {
            hiddenLocalFilesIndexPath = indexPath
            DispatchQueue.main.async { collectionView.reloadData() }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
