import SwiftUI
import UIKit

struct OmneonGeneralSettingsView: View {

    var body: some View {
        List {

            Section {
                Toggle(
                    "remove_explicit_icon".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.removeExplicitIcon },
                        set: { UserDefaults.removeExplicitIcon = $0 }
                    )
                )
                Toggle(
                    "hide_create_tab".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideCreateTab },
                        set: { UserDefaults.hideCreateTab = $0 }
                    )
                )
                Toggle(
                    "make_tab_bar_not_transparent".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.makeTabBarNotTransparent },
                        set: { UserDefaults.makeTabBarNotTransparent = $0 }
                    )
                )
            }

            NonIPadSpacerView()
        }

        .listStyle(GroupedListStyle())
    }
}
