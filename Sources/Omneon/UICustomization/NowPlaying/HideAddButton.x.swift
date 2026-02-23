import Orion
import UIKit
import SwiftUI

struct HideAddButton: HookGroup { }

class SPTPlayerTrack_OmneonHook_1: ClassHook<NSObject> {
  typealias Group = HideAddButton
  static let targetName = "SPTPlayerTrack"

  func metadata() -> [String: String] {
      var meta = orig.metadata()
      meta["collection.can_add"] = "false"
      return meta
  }
}
