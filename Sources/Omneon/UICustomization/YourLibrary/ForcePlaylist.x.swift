import Orion
import UIKit
import SwiftUI

struct ForcePlaylist: HookGroup { }

class YourLibrarySelectedSortOrderImpl_Hook: ClassHook<NSObject> {
    typealias Group = ForcePlaylist
    static let targetName = "YourLibrary_YourLibraryXImpl.YourLibrarySelectedSortOrderImpl"

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        logIvars()
    }

    private func logIvars() {
        var count: UInt32 = 0
        let ivars = class_copyIvarList(type(of: target), &count)
        for i in 0..<Int(count) {
            if let ivar = ivars?[i] {
                let name = String(cString: ivar_getName(ivar)!)
                let value = object_getIvar(target, ivar)
                NSLog("[Omneon] YourLibrarySelectedSortOrderImpl ivar \(name): \(String(describing: value))")
            }
        }
        free(ivars)
    }
}

class CEFilterAndSortRowPresenter_Hook: ClassHook<NSObject> {
    typealias Group = ForcePlaylist
    static let targetName = "CollectionEpisodes_PlaylistImpl.CEFilterAndSortRowPresenter"

    func viewDidLayoutSubviews() {
        orig.viewDidLayoutSubviews()
        logIvars()
    }

    private func logIvars() {
        var count: UInt32 = 0
        let ivars = class_copyIvarList(type(of: target), &count)
        for i in 0..<Int(count) {
            if let ivar = ivars?[i] {
                let name = String(cString: ivar_getName(ivar)!)
                let value = object_getIvar(target, ivar)
                NSLog("[Omneon] CEFilterAndSortRowPresenter ivar \(name): \(String(describing: value))")
            }
        }
        free(ivars)
    }
}
