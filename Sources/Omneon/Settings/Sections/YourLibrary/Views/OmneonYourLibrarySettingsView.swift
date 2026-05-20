import SwiftUI
import UIKit

struct OmneonYourLibrarySettingsView: View {
    var body: some View {
        List {
            
            //Main view (aka when not inside playlist)
            Section {
                Toggle(
                    "force_playlist".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.forcePlaylist },
                        set: { UserDefaults.forcePlaylist = $0 }
                    )
                )
                Toggle(
                    "hide_local_files".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideLocalFiles },
                        set: { UserDefaults.hideLocalFiles = $0 }
                    )
                )
            } header: {
                Text("main_view".localized)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .textCase(nil)
                    .padding(.bottom, 4)
            }

            NonIPadSpacerView()
        }
        .listStyle(GroupedListStyle())
    }
}
