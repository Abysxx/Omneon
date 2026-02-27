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
                    "hide_bluetooth_button".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideBluetoothButton },
                        set: { UserDefaults.hideBluetoothButton = $0 }
                    )
                )
                Toggle(
                    "hide_share_button".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideShareButton },
                        set: { UserDefaults.hideShareButton = $0 }
                    )
                )
                Toggle(
                    "hide_queue_button".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideQueueButton },
                        set: { UserDefaults.hideQueueButton = $0 }
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
                        // Scroll view elements
            Section {
                Toggle(
                    "hide_big_bluetooth_icon".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideBigBluetoothIcon },
                        set: { UserDefaults.hideBigBluetoothIcon = $0 }
                    )
                )
                Toggle(
                    "hide_small_bluetooth_icon".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.hideSmallBluetoothIcon },
                        set: { UserDefaults.hideSmallBluetoothIcon = $0 }
                    )
                )
                Toggle(
                    "center_title".localized,
                    isOn: Binding<Bool>(
                        get: { UserDefaults.centerTitle },
                        set: { UserDefaults.centerTitle = $0 }
                    )
                )
            } header: {
                Text("now_playing_bar".localized)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .textCase(nil)
            } footer: {Text("center_title_footer".localized)}
            // Footer for whole section even tho its just for the last one

            NonIPadSpacerView()
        }
        .listStyle(GroupedListStyle())
    }
}
