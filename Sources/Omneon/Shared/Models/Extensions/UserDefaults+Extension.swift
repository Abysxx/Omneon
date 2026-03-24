import Foundation

extension UserDefaults {
    static var container: UserDefaults = .standard
    // General
    private static let removeExplicitIconKey = "removeExplicitIcon"
    private static let hideCreateTabKey = "hideCreateTab"
    private static let makeTabBarNotTransparentKey = "makeTabBarNotTransparent"
    // Now Playing
    private static let hideAddButtonKey = "hideAddButton"
    private static let hideBanButtonKey = "hideBanButton"

    private static let hideBluetoothButtonKey = "hideBluetoothButton"
    private static let hideQueueButtonKey = "hideQueueButton"
    private static let hideShareButtonKey = "hideShareIcon"
    
    private static let hideExploreKey = "hideExplore"
    private static let hideCreditsKey = "hideCredits"
    private static let hideAboutArtistKey = "hideAboutArtist"
    private static let hideLyricsCardKey = "hideLyricsCard"
    private static let hideOnTourCardKey = "hideOnTourCard"
    private static let hideReleaseCountdownCardKey = "hideReleaseCountdownCard"
    private static let hideMerchCardKey = "hideMerchCard"

    private static let hideSmallBluetoothIconKey = "hideSmallBluetoothIcon"
    private static let hideBigBluetoothIconKey = "hideBigBluetoothIcon"
    private static let centerTitleKey = "centerTitle"
    // Your Library
    private static let forcePlaylistKey = "forcePlaylist"
    // Misc/Dev
    private static let fuxkPostseasonKey = "fuxkPostseason"
    private static let replaceWithLocalKey = "replaceWithLocal"
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
    static var hideCreateTab: Bool {
        get {
            container.object(forKey: hideCreateTabKey) as? Bool ?? false
        }
        set (hideCreateTab) {
            container.set(hideCreateTab, forKey: hideCreateTabKey)
        }
    }
    static var makeTabBarNotTransparent: Bool {
        get {
            container.object(forKey: makeTabBarNotTransparentKey) as? Bool ?? false
        }
        set (makeTabBarNotTransparent) {
            container.set(makeTabBarNotTransparent, forKey: makeTabBarNotTransparentKey)
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
    static var hideBluetoothButton: Bool {
        get {
            container.object(forKey: hideBluetoothButtonKey) as? Bool ?? false
        }
        set (hideBluetoothButton) {
            container.set(hideBluetoothButton, forKey: hideBluetoothButtonKey)
        }
    }
    static var hideQueueButton: Bool {
        get {
            container.object(forKey: hideQueueButtonKey) as? Bool ?? false
        }
        set (hideQueueButton) {
            container.set(hideQueueButton, forKey: hideQueueButtonKey)
        }
    }
    static var hideShareButton: Bool {
        get {
            container.object(forKey: hideShareButtonKey) as? Bool ?? false
        }
        set (hideShareButton) {
            container.set(hideShareButton, forKey: hideShareButtonKey)
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
    static var hideOnTourCard: Bool {
        get {
            container.object(forKey: hideOnTourCardKey) as? Bool ?? false
        }
        set (hideOnTourCard) {
            container.set(hideOnTourCard, forKey: hideOnTourCardKey)
        }
    }
    static var hideReleaseCountdownCard: Bool {
        get {
            container.object(forKey: hideReleaseCountdownCardKey) as? Bool ?? false
        }
        set (hideReleaseCountdownCard) {
            container.set(hideReleaseCountdownCard, forKey: hideReleaseCountdownCardKey)
        }
    }
    static var hideMerchCard: Bool {
        get {
            container.object(forKey: hideMerchCardKey) as? Bool ?? false
        }
        set (hideMerchCard) {
            container.set(hideMerchCard, forKey: hideMerchCardKey)
        }
    }
    /// Bar
    static var hideSmallBluetoothIcon: Bool {
        get {
            container.object(forKey: hideSmallBluetoothIconKey) as? Bool ?? false
        }
        set (hideSmallBluetoothIcon) {
            container.set(hideSmallBluetoothIcon, forKey: hideSmallBluetoothIconKey)
        }
    }
    static var hideBigBluetoothIcon: Bool {
        get {
            container.object(forKey: hideBigBluetoothIconKey) as? Bool ?? false
        }
        set (hideBigBluetoothIcon) {
            container.set(hideBigBluetoothIcon, forKey: hideBigBluetoothIconKey)
        }
    }
    static var centerTitle: Bool {
        get {
            container.object(forKey: centerTitleKey) as? Bool ?? false
        }
        set (centerTitle) {
            container.set(centerTitle, forKey: centerTitleKey)
        }
    }
    ///
    /// Your Library
    ///
    static var forcePlaylist: Bool {
        get {
            container.object(forKey: forcePlaylistKey) as? Bool ?? false
        }
        set (forcePlaylist) {
            container.set(forcePlaylist, forKey: forcePlaylistKey)
        }
    }
    ///
    /// Misc/Dev
    ///
    static var fuxkPostseason: Bool {
        get {
            container.object(forKey: fuxkPostseasonKey) as? Bool ?? false
        }
        set (fuxkPostseason) {
            container.set(fuxkPostseason, forKey: fuxkPostseasonKey)
        }
    }
    static var replaceWithLocal: Bool {
        get {
            container.object(forKey: replaceWithLocalKey) as? Bool ?? false
        }
        set (replaceWithLocal) {
            container.set(replaceWithLocal, forKey: replaceWithLocalKey)
        }
    }
}
