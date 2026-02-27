import Orion
import UIKit
import SwiftUI

struct CenterTitle: HookGroup { }

class NowPlaying_BarImpl_ContentViewControllerImplementation_Hook_2: ClassHook<UIViewController> {
    typealias Group = CenterTitle
    static let targetName = "NowPlaying_BarImpl.ContentViewControllerImplementation"
    
    private let hideIndex: Int = 3

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()

        guard let root = target.view, root.subviews.count >= 5 else { return }
        let viewToCenter = root.subviews[hideIndex]
        // shift the frame down 8 on the y-axis
        var frame = viewToCenter.frame
        frame.origin.y = 8
        viewToCenter.frame = frame
    }
}
