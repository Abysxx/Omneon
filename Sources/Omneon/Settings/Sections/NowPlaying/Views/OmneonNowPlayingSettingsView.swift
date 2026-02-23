import SwiftUI
import UIKit

struct OmneonNowPlayingSettingsView: View {

    var body: some View {
        List {

            Section {
                Toggle(
                    "hide_add_button".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideAddButton },
                        set: { UserDefaults.hideAddButton = $0 }
                    )
                )

                Toggle(
                    "hide_ban_button".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideBanButton },
                        set: { UserDefaults.hideBanButton = $0 }
                    )
                )
                
                Toggle(
                    "hide_explore".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideExplore },
                        set: { UserDefaults.hideExplore = $0 }
                    )
                )
                Toggle(
                    "hide_credits".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideCredits },
                        set: { UserDefaults.hideCredits = $0 }
                    )
                )
            }

            NonIPadSpacerView()
        }

        .listStyle(GroupedListStyle())
    }
}
