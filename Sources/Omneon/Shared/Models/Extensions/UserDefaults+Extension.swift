import Foundation

extension UserDefaults {
    static var container: UserDefaults = .standard

    private static let removeExplicitIconKey = "removeExplicitIcon"
    
    private static let hideAddButtonKey = "hideAddButton"
    private static let hideBanButtonKey = "hideBanButton"

    private static let hideBluetoothIconKey = "hideBluetoothIcon"
    private static let hideQueueIconKey = "hideQueueIcon"
    private static let hideShareIconKey = "hideShareIcon"
    
    private static let hideExploreKey = "hideExplore"
    private static let hideCreditsKey = "hideCredits"
    private static let hideAboutArtistKey = "hideAboutArtist"
    private static let hideLyricsCardKey = "hideLyricsCard"
    ///
    /// General
    ///
    static var removeExplicitIcon: Bool {
        get {
            container.object(forKey: removeExplicitIconKey) as? Bool ?? false
        }
        set (removeExplicitIcon) {
            container.set(removeExplicitIcon, forKey: removeExplicitIconKey)
        }
    }
    ///
    /// NowPlaying
    ///
    /// Information Elements
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
    /// Footer Elements
    static var hideBluetoothIcon: Bool {
        get {
            container.object(forKey: hideBluetoothIconKey) as? Bool ?? false
        }
        set (hideBluetoothIcon) {
            container.set(hideBluetoothIcon, forKey: hideBluetoothIconKey)
        }
    }
    static var hideQueueIcon: Bool {
        get {
            container.object(forKey: hideQueueIconKey) as? Bool ?? false
        }
        set (hideQueueIcon) {
            container.set(hideQueueIcon, forKey: hideQueueIconKey)
        }
    }
    static var hideShareIcon: Bool {
        get {
            container.object(forKey: hideShareIconKey) as? Bool ?? false
        }
        set (hideShareIcon) {
            container.set(hideShareIcon, forKey: hideShareIconKey)
        }
    }
    /// Scroll View
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
    static var hideAboutArtist: Bool {
        get {
            container.object(forKey: hideAboutArtistKey) as? Bool ?? false
        }
        set (hideAboutArtist) {
            container.set(hideAboutArtist, forKey: hideAboutArtistKey)
        }
    }
    static var hideLyricsCard: Bool {
        get {
            container.object(forKey: hideLyricsCardKey) as? Bool ?? false
        }
        set (hideLyricsCard) {
            container.set(hideLyricsCard, forKey: hideLyricsCardKey)
        }
    }
}
