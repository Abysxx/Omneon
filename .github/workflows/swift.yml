import Orion
import UIKit
import SwiftUI

struct RemoveExplicitIcon: HookGroup { }

class SPTPlayerTrack_OmneonHook: ClassHook<NSObject> {
  typealias Group = RemoveExplicitIcon
  static let targetName = "SPTPlayerTrack"

  func metadata() -> [String: String] {
      var meta = orig.metadata()
      meta["is_explicit"] = "false"
      return meta
  }
}

class SPTEncoreLabel_OmneonHook: ClassHook<UIView> {
    typealias Group = RemoveExplicitIcon
    static let targetName = "SPTEncoreLabel"

    func isHidden() -> Bool {
        let originalHidden = orig.isHidden()

        if target.accessibilityIdentifier == "Components.UI.ExplicitIcon",
           originalHidden == false {
            target.alpha = 0.0
            return true
        }

        return originalHidden
    }
}
