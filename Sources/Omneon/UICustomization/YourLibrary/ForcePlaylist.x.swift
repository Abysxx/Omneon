import Orion
import UIKit
import SwiftUI

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

var DidForcePlaylistAlready = false
struct ForcePlaylist: HookGroup { }

class EncoreCollectionView_Hook: ClassHook<NSObject> {
    typealias Group = ForcePlaylist
    static let targetName = "_TtCE28EncoreConsumerMobile_BaseKitO19LegacyUI_ECMCoreKit5Views14CollectionView"

    @objc(collectionView:didSelectItemAtIndexPath:)
    func collectionView(_ collectionView: AnyObject, didSelectItemAtIndexPath indexPath: AnyObject) {
        var output = "didSelectItemAtIndexPath called\n"
        for (i, symbol) in Thread.callStackSymbols.enumerated() {
            if symbol.contains("Spotify") || symbol.contains("YourLibrary") || symbol.contains("Encore") {
                output += "[\(i)] \(symbol)\n"
            }
        }
        let path = "/var/jb/var/mobile/Documents/encore_callstack.txt"
        let existing = (try? String(contentsOfFile: path)) ?? ""
        try? (existing + output + "\n---\n").write(toFile: path, atomically: true, encoding: .utf8)
        NSLog("[Omneon] wrote callstack to \(path)")
        orig.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
    }
}

class YourLibraryViewController_Hook: ClassHook<UIViewController> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibraryViewController"

    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        if DidForcePlaylistAlready { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let view = self.target.view
            guard
                let s0 = view?.subviews[safe: 0],
                let s1 = s0.subviews[safe: 1],
                let s2 = s1.subviews[safe: 1],
                let s3 = s2.subviews[safe: 0],
                let s4 = s3.subviews[safe: 0],
                let s5 = s4.subviews[safe: 0],
                let collectionView = s5.subviews[safe: 0] as? UICollectionView
            else { return }

            NSLog("[Omneon] found collectionView: \(collectionView.accessibilityIdentifier ?? "no id")")
            NSLog("[Omneon] delegate: \(String(describing: collectionView.delegate))")
            NSLog("[Omneon] delegate class: \(NSStringFromClass(type(of: collectionView.delegate as AnyObject)))")
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
            DidForcePlaylistAlready = true
        }
    }
}
