import Orion
import UIKit
import SwiftUI

struct HideLocalFiles: HookGroup { }

class HideLocalFiles_DebugHook: ClassHook<UIViewController> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

    func viewDidAppear(_ animated: Bool) {
        NSLog("[Omneon] viewDidAppear fired")
        orig.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let view = self.target.view
            guard
                let s0 = view?.subviews[safe: 0],
                let s1 = s0.subviews[safe: 0],
                let collectionView = s1.subviews[safe: 0] as? UICollectionView
            else {
                NSLog("[Omneon] guard failed")
                return
            }
    
            var output = "=== DEBUG DUMP ===\n"
            output += "collectionView class: \(NSStringFromClass(type(of: collectionView)))\n"
            output += "numberOfItems: \(collectionView.numberOfItems(inSection: 0))\n"
            output += "dataSource: \(NSStringFromClass(type(of: collectionView.dataSource as AnyObject)))\n"
            output += "delegate: \(NSStringFromClass(type(of: collectionView.delegate as AnyObject)))\n"
            output += "layout: \(NSStringFromClass(type(of: collectionView.collectionViewLayout)))\n\n"
    
            for (i, cell) in collectionView.visibleCells.enumerated() {
                let ip = collectionView.indexPath(for: cell)
                output += "cell[\(i)] indexPath=\(String(describing: ip)) reuseId=\(cell.reuseIdentifier ?? "nil") class=\(NSStringFromClass(type(of: cell)))\n"
                for (j, sub) in cell.subviews.enumerated() {
                    output += "  sub[\(j)]: \(NSStringFromClass(type(of: sub))) id=\(sub.accessibilityIdentifier ?? "nil")\n"
                    for (k, sub2) in sub.subviews.enumerated() {
                        output += "    sub[\(j)][\(k)]: \(NSStringFromClass(type(of: sub2))) id=\(sub2.accessibilityIdentifier ?? "nil")\n"
                        for (l, sub3) in sub2.subviews.enumerated() {
                            output += "      sub[\(j)][\(k)][\(l)]: \(NSStringFromClass(type(of: sub3))) id=\(sub3.accessibilityIdentifier ?? "nil")\n"
                        }
                    }
                }
            }
    
            let path = "/var/jb/var/mobile/Documents/localfiles_debug.txt"
            do {
                try output.write(toFile: path, atomically: true, encoding: .utf8)
                NSLog("[Omneon] dumped to \(path)")
            } catch {
                NSLog("[Omneon] write failed: \(error)")
            }
        }
    }
}

class HideLocalFiles_DataSourceDebug: ClassHook<NSObject> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryContentViewBinder"

    @objc(collectionView:numberOfItemsInSection:)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = orig.collectionView(collectionView, numberOfItemsInSection: section)
        NSLog("[Omneon] numberOfItems: \(count)")
        return count
    }

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        NSLog("[Omneon] cellForItemAt \(indexPath) reuseId=\(cell.reuseIdentifier ?? "nil") class=\(NSStringFromClass(type(of: cell)))")
        return cell
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        NSLog("[Omneon] willDisplay \(indexPath) reuseId=\(cell.reuseIdentifier ?? "nil")")
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    @objc(collectionView:didSelectItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("[Omneon] didSelectItemAt \(indexPath)")
        orig.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
