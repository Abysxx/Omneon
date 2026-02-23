import Foundation

extension UserDefaults {
    static var container: UserDefaults = .standard

    private static let removeExplicitIconKey = "removeExplicitIcon"
    private static let hideAddButtonKey = "hideAddButton"
    private static let hideBanButtonKey = "hideBanButton"
    private static let hideExploreKey = "hideExplore"
    private static let hideCreditsKey = "hideCredits"

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
    
    static var hideExplore: Bool {
        get {
            container.object(forKey: hideExploreKey) as? Bool ?? false
        }
        set (hideExplore) {
            container.set(hideExplore, forKey: hideExploreKey)
        }
    }
    
    static var hideCredits: Bool {
        get {
            container.object(forKey: hideCreditsKey) as? Bool ?? false
        }
        set (hideCredits) {
            container.set(hideCredits, forKey: hideCreditsKey)
        }
    }
}
