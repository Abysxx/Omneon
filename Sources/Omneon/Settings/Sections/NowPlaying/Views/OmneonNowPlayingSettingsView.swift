import SwiftUI
import UIKit

struct OmneonNowPlayingSettingsView: View {
    var body: some View {
        List {
            
            //Information Elements
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
            } header: {
                Text("information_elements".localized)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .textCase(nil)
                    .padding(.bottom, 4)
            }
            
            //Footer Elements
            Section {
                Toggle(
                    "hide_bluetooth_icon".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideBluetoothIcon },
                        set: { UserDefaults.hideBluetoothIcon = $0 }
                    )
                )
                Toggle(
                    "hide_queue_icon".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideQueueIcon },
                        set: { UserDefaults.hideQueueIcon = $0 }
                    )
                )
                Toggle(
                    "hide_share_icon".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideShareIcon },
                        set: { UserDefaults.hideShareIcon = $0 }
                    )
                )
            } header: {
                Text("footer_elements".localized)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .textCase(nil)
                    .padding(.bottom, 4)
            }
            
            // Scroll view elements
            Section {
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
                Toggle(
                    "hide_about_artist".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideAboutArtist },
                        set: { UserDefaults.hideAboutArtist = $0 }
                    )
                )
                Toggle(
                    "hide_lyrics_card".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideLyricsCard },
                        set: { UserDefaults.hideLyricsCard = $0 }
                    )
                )
            } header: {
                Text("scroll_view_elements".localized)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .textCase(nil)
            }

            NonIPadSpacerView()
        }
        .listStyle(GroupedListStyle())
    }
}
