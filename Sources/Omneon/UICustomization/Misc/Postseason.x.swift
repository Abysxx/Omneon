import Orion
import UIKit
import SwiftUI

//testing...
struct Postseason: HookGroup { }

class SPTPlayerTrack_OmneonHook_2: ClassHook<NSObject> {
  typealias Group = Postseason
  static let targetName = "SPTPlayerTrack"

  func metadata() -> [String: String] {
      var meta = orig.metadata()
      if(meta["title"] == "#BoxOnnaBack"){
        meta["image_small_url"] = "https://i1.sndcdn.com/artworks-C9hhnPzL19C0iclt-NqJ4IQ-t1080x1080.jpg"
        meta["image_url"] = "https://i1.sndcdn.com/artworks-C9hhnPzL19C0iclt-NqJ4IQ-t1080x1080.jpg"
        meta["image_large_url"] = "https://i1.sndcdn.com/artworks-C9hhnPzL19C0iclt-NqJ4IQ-t1080x1080.jpg"
        meta["image_xlarge_url"] = "https://i1.sndcdn.com/artworks-C9hhnPzL19C0iclt-NqJ4IQ-t1080x1080.jpg"
      }
      return meta
  }
}
