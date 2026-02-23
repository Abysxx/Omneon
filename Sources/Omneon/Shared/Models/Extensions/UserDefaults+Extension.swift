import Foundation

extension UserDefaults {
    static var container: UserDefaults = .standard

    private static let removeExplicitIconKey = "removeExplicitIcon"

    static var removeExplicitIcon: Bool {
        get {
            container.object(forKey: removeExplicitIconKey) as? Bool ?? false
        }
        set (removeExplicitIcon) {
            container.set(removeExplicitIcon, forKey: removeExplicitIconKey)
        }
    }
}
