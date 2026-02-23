import Orion
import UIKit
import SwiftUI

struct HideBanButton: HookGroup { }

class SPTPlayerTrack_OmneonHook_2: ClassHook<NSObject> {
  typealias Group = HideBanButton
  static let targetName = "SPTPlayerTrack"

  func metadata() -> [String: String] {
      var meta = orig.metadata()
      meta["collection.can_ban"] = "false"
      return meta
  }
}
