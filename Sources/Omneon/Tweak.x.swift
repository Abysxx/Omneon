import Orion
import UIKit

func exitApplication() {
    UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
        exit(EXIT_SUCCESS)
    }
}

struct Omneon: Tweak {
    static let version = "0.2.0"
    //I don't care about supporting certain app versions. at least right now
    init() {
        //General
        if UserDefaults.removeExplicitIcon {
            RemoveExplicitIcon().activate()
        }
        if UserDefaults.hideCreateTab {
            HideCreateTab().activate()
        }
        if UserDefaults.makeTabBarNotTransparent {
            MakeTabBarNotTransparent().activate()
        }
        //NowPlaying InformationElements
        if UserDefaults.hideAddButton {
            HideAddButton().activate()
        }
        if UserDefaults.hideBanButton {
            HideBanButton().activate()
        }
        // NowPlaying FooterElements
        if UserDefaults.hideBluetoothButton {
            HideBluetoothButton().activate()
        }
        if UserDefaults.hideShareButton {
            HideShareButton().activate()
        }
        if UserDefaults.hideQueueButton {
            HideQueueButton().activate()
        }
        // NowPlaying ScrollView
        if UserDefaults.hideExplore {
            HideExplore().activate()
        }
        if UserDefaults.hideCredits {
            HideCredits().activate()
        }
        if UserDefaults.hideAboutArtist {
            HideAboutArtist().activate()
        }
        if UserDefaults.hideLyricsCard {
            HideLyricsCard().activate()
        }
        // NowPlaying Bar
        if UserDefaults.hideBigBluetoothIcon {
            HideBigBluetoothIcon().activate()
        }
        if UserDefaults.hideSmallBluetoothIcon {
            HideSmallBluetoothIcon().activate()
        }
        if UserDefaults.centerTitle {
            CenterTitle().activate()
        }
        ForcePlaylist().activate()

    }
}
