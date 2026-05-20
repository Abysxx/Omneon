import Orion
import UIKit
import SwiftUI

class HideLocalFiles_DebugHook: ClassHook<UIViewController> {
    typealias Group = HideLocalFiles
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

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

        var output = "=== DEBUG DUMP ===\n"
        output += "dataSource: \(String(describing: collectionView.dataSource))\n"
        output += "delegate: \(String(describing: collectionView.delegate))\n"
        output += "layout: \(String(describing: collectionView.collectionViewLayout))\n"
        output += "numberOfItems: \(collectionView.numberOfItems(inSection: 0))\n"
        output += "visibleCells: \(collectionView.visibleCells.count)\n\n"

        for (i, cell) in collectionView.visibleCells.enumerated() {
            let ip = collectionView.indexPath(for: cell)
            output += "--- visibleCell[\(i)] indexPath=\(String(describing: ip)) ---\n"
            output += "  class: \(NSStringFromClass(type(of: cell)))\n"
            output += "  reuseIdentifier: \(cell.reuseIdentifier ?? "nil")\n"
            output += "  isHidden: \(cell.isHidden)\n"
            output += "  frame: \(cell.frame)\n"
            for (j, sub) in cell.subviews.enumerated() {
                output += "  subview[\(j)]: \(NSStringFromClass(type(of: sub))) id=\(sub.accessibilityIdentifier ?? "nil")\n"
                for (k, sub2) in sub.subviews.enumerated() {
                    output += "    subview[\(j)][\(k)]: \(NSStringFromClass(type(of: sub2))) id=\(sub2.accessibilityIdentifier ?? "nil")\n"
                    for (l, sub3) in sub2.subviews.enumerated() {
                        output += "      subview[\(j)][\(k)][\(l)]: \(NSStringFromClass(type(of: sub3))) id=\(sub3.accessibilityIdentifier ?? "nil")\n"
                    }
                }
            }
        }

        // dump reuse queues via ivar
        var ivarCount: UInt32 = 0
        let ivars = class_copyIvarList(type(of: collectionView), &ivarCount)
        output += "\n=== COLLECTION VIEW IVARS ===\n"
        for i in 0..<Int(ivarCount) {
            if let ivar = ivars?[i] {
                let name = String(cString: ivar_getName(ivar)!)
                let typeEncoding = String(cString: ivar_getTypeEncoding(ivar)!)
                if typeEncoding.hasPrefix("@") {
                    let value = object_getIvar(collectionView, ivar)
                    output += "  \(name): \(String(describing: value))\n"
                } else {
                    output += "  \(name): <non-object \(typeEncoding)>\n"
                }
            }
        }
        free(ivars)

        let path = "/var/jb/var/mobile/Documents/localfiles_debug.txt"
        try? output.write(toFile: path, atomically: true, encoding: .utf8)
        NSLog("[Omneon] debug dumped to \(path)")
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
