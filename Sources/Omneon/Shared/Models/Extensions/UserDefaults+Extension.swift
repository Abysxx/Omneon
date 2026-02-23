import Foundation

extension UserDefaults {
    static var container: UserDefaults = .standard

    private static let removeExplicitIconKey = "removeExplicitIcon"
    private static let hideAddButton = "hideAddButton"
    private static let hideBanButton = "hideBanButton"

    static var removeExplicitIcon: Bool {
        get {
            container.object(forKey: removeExplicitIconKey) as? Bool ?? false
        }
        set (removeExplicitIcon) {
            container.set(removeExplicitIcon, forKey: removeExplicitIconKey)
        }
    }

    static var hideAddButton: Bool {
        get {
            container.object(forKey: hideAddButtonKey) as? Bool ?? false
        }
        set (hideAddButton) {
            container.set(hideAddButton, forKey: hideAddButtonKey)
        }
    }

    static var hideBanButton: Bool {
        get {
            container.object(forKey: hideBanButtonKey) as? Bool ?? false
        }
        set (hideBanButton) {
            container.set(hideBanButton, forKey: hideBanButtonKey)
        }
    }
}
