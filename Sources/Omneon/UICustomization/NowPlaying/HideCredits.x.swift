import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

var hiddenIndexPath_2: IndexPath? = nil

func scanAndHideCredits(in collectionView: UICollectionView) {
    for cell in collectionView.visibleCells {
        if containsIdentifier(cell, identifier: "TrackCredits.Card"),
           let indexPath = collectionView.indexPath(for: cell) {
            if hiddenIndexPath_2 != indexPath {
                hiddenIndexPath_2 = indexPath
                collectionView.reloadItems(at: [indexPath])
            }
            break
        }
    }
}

class HideCredits_ViewControllerHook: ClassHook<UIViewController> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.NowPlayingScrollViewController"

    @objc(nowPlayingScrollViewModelWithDidLoadComponentsFor:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidLoadComponents(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidLoadComponents(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)

        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else {
            NSLog("[Omneon] Could not get collectionView")
            return
        }

        // Log components to file
        var output = "[Omneon] Loaded components:\n"
        for section in 0..<collectionView.numberOfSections {
            output += "  Section \(section) - \(collectionView.numberOfItems(inSection: section)) items\n"
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                if let cell = collectionView.cellForItem(at: indexPath) {
                    output += "    [\(section),\(item)] class: \(NSStringFromClass(type(of: cell)))"
                    if let id = cell.accessibilityIdentifier { output += " id: \(id)" }
                    output += "\n"
                    func logSubviews(_ view: UIView, indent: Int) {
                        for subview in view.subviews {
                            let pad = String(repeating: "  ", count: indent)
                            output += "\(pad)- \(NSStringFromClass(type(of: subview)))"
                            if let id = subview.accessibilityIdentifier { output += " id: \(id)" }
                            output += "\n"
                            logSubviews(subview, indent: indent + 1)
                        }
                    }
                    logSubviews(cell, indent: 3)
                } else {
                    output += "    [\(section),\(item)] (not visible/loaded)\n"
                }
            }
        }
        let path = "/var/jb/var/mobile/Documents/omneon_dump.txt"
        try? output.write(toFile: path, atomically: true, encoding: .utf8)
        NSLog("[Omneon] Dump written to \(path)")

        // Scan and hide
        scanAndHideCredits(in: collectionView)
    }

    @objc(nowPlayingScrollViewModelWithDidMoveToRelativeTrack:withDifferentProviders:scrollEnabledValueChanged:)
    func nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for arg1: AnyObject, withDifferentProviders arg2: Bool, scrollEnabledValueChanged arg3: Bool) {
        orig.nowPlayingScrollViewModelWithDidMoveToRelativeTrack(for: arg1, withDifferentProviders: arg2, scrollEnabledValueChanged: arg3)
        guard let collectionView = target.value(forKey: "collectionView") as? UICollectionView else { return }
        hiddenIndexPath_2 = nil
        scanAndHideCredits(in: collectionView)
    }
}

class HideCredits_DelegateHook: ClassHook<NSObject> {
    typealias Group = HideCredits
    static let targetName = "NowPlaying_ScrollImpl.ScrollCollectionViewManagerWithDynamicSizingImplementation"

    @objc(collectionView:cellForItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath == hiddenIndexPath_2 {
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TRACK_CREDITS")
            return collectionView.dequeueReusableCell(withReuseIdentifier: "TRACK_CREDITS", for: indexPath)
        }
        let cell = orig.collectionView(collectionView, cellForItemAt: indexPath)
        if containsIdentifier(cell, identifier: "TrackCredits.Card") {
            hiddenIndexPath_2 = indexPath
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TRACK_CREDITS")
            return collectionView.dequeueReusableCell(withReuseIdentifier: "TRACK_CREDITS", for: indexPath)
        }
        return cell
    }

    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == hiddenIndexPath_2 {
            cell.layoutIfNeeded()
            cell.isHidden = true
            cell.constraints.filter { $0.identifier == "HideCredits_ZeroHeight" }.forEach { $0.isActive = false }
            cell.contentView.constraints.forEach { $0.isActive = $0.firstAttribute != .height }
            cell.constraints.forEach { $0.isActive = $0.firstAttribute != .height }
            let zeroHeight = cell.heightAnchor.constraint(equalToConstant: 0)
            zeroHeight.priority = .required
            zeroHeight.identifier = "HideCredits_ZeroHeight"
            zeroHeight.isActive = true
            cell.layoutIfNeeded()
            DispatchQueue.main.async {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
        orig.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }

    @objc(collectionView:layout:insetForSectionAtIndex:)
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var insets = orig.collectionView(collectionView, layout: layout, insetForSectionAt: section)
        if hiddenIndexPath_2 != nil {
            insets.bottom -= 100
        }
        return insets
    }
}
