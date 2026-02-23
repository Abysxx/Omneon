import Orion
import UIKit

func exitApplication() {
    UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
        exit(EXIT_SUCCESS)
    }
}

struct Omneon: Tweak {
    static let version = "0.0.1"
    //I don't care about supporting certain app versions. at least right now
    init() {

        if UserDefaults.removeExplicitIcon {
            RemoveExplicitIcon().activate()
        }
        if UserDefaults.hideAddButton {
            HideAddButton().activate()
        }
        if UserDefaults.hideBanButton {
            HideBanButton().activate()
        }

    }
}
