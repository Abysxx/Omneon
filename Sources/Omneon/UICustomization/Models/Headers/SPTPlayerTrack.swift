import Foundation

@objc protocol SPTPlayerTrack {
    func setMetadata(_ metadata: [String:String])
    func metadata() -> [String:String]
}
