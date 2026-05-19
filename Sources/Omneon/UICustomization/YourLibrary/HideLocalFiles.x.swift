import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }

var hiddenLocalFilesIndexPath: IndexPath? = nil

class YourLibraryContentViewBinder_Hook: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryContentViewBinder"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        return hiddenLocalFilesIndexPath != nil ? count - 1 : count
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hidden = hiddenLocalFilesIndexPath else {
            let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
            if let view = cell.subviews[safe: 2]?.subviews[safe: 0]?.subviews[safe: 0],
               view.accessibilityIdentifier == "LocalFiles.Row.Library" {
                hiddenLocalFilesIndexPath = indexPath
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
        NSLog("[Omneon] willDisplay cell at \(indexPath) subviews: \(cell.subviews.count)")
        if let s2 = cell.subviews[safe: 2] {
            NSLog("[Omneon] subviews[2] subviews: \(s2.subviews.count)")
            if let s0 = s2.subviews[safe: 0] {
                NSLog("[Omneon] subviews[2][0] subviews: \(s0.subviews.count)")
                if let s00 = s0.subviews[safe: 0] {
                    NSLog("[Omneon] subviews[2][0][0] accessibilityIdentifier: \(s00.accessibilityIdentifier ?? "nil")")
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
