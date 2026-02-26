import Orion
import UIKit
import Foundation

struct HideCredits: HookGroup {}

var hiddenIndexPath_2: IndexPath? = nil

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
        
        var output = "[Omneon] Loaded components:\n"
        for section in 0..<collectionView.numberOfSections {
            output += "  Section \(section) - \(collectionView.numberOfItems(inSection: section)) items\n"
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                if let cell = collectionView.cellForItem(at: indexPath) {
                    output += "    [\(section),\(item)] class: \(NSStringFromClass(type(of: cell)))"
                    if let id = cell.accessibilityIdentifier {
                        output += " id: \(id)"
                    }
                    output += "\n"
                    // Log all subview identifiers
                    func logSubviews(_ view: UIView, indent: Int) {
                        for subview in view.subviews {
                            let pad = String(repeating: "  ", count: indent)
                            output += "\(pad)- \(NSStringFromClass(type(of: subview)))"
                            if let id = subview.accessibilityIdentifier {
                                output += " id: \(id)"
                            }
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
        NSLog(output)
    }
}
