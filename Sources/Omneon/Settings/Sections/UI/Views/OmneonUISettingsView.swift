import SwiftUI
import UIKit

struct OmneonUISettingsView: View {

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
            }

            NonIPadSpacerView()
        }

        .listStyle(GroupedListStyle())
    }
}
