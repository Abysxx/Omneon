import SwiftUI
import UIKit

struct OmneonMiscSettingsView: View {
    var body: some View {
        List {
            
            Section {
                Toggle(
                    "postseason".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.fuxkPostseason },
                        set: { UserDefaults.fuxkPostseason = $0 }
                    )
                )
            }
            
            NonIPadSpacerView()
        }
        .listStyle(GroupedListStyle())
    }
}
