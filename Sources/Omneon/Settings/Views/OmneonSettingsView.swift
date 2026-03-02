import SwiftUI
import UIKit

struct OmneonSettingsView: View {
    let navigationController: UINavigationController
    static let spotifyAccentColor = Color(hex: "#1ed760")

    @State private var isClearingData = false

    private func pushSettingsController(with view: any View, title: String) {
        let viewController = OmneonSettingsViewController(
            navigationController.view.frame,
            settingsView: AnyView(view),
            navigationTitle: title
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        UIView.appearance().tintColor = UIColor(OmneonSettingsView.spotifyAccentColor)
    }

    var body: some View {
        List {
            OmneonSettingsVersionView()

            //
            Section(footer: Text("restart_is_required_description".localized)){
                Button {
                    pushSettingsController(
                        with: OmneonGeneralSettingsView(),
                        title: "general".localized
                    )
                } label: {
                    NavigationSectionView(
                        color: Color(hex: "#64D2FF"),
                        title: "general".localized,
                        imageSystemName: "paintpalette.fill"
                    )
                }
    
                Button {
                    pushSettingsController(
                        with: OmneonNowPlayingSettingsView(),
                        title: "now_playing".localized
                    )
                } label: {
                    NavigationSectionView(
                        color: Color(hex: "#64D2FF"),
                        title: "now_playing".localized,
                        imageSystemName: "paintpalette.fill"
                    )
                }
    
                Button {
                    pushSettingsController(
                        with: OmneonNowPlayingSettingsView(),
                        title: "your_library".localized
                    )
                } label: {
                    NavigationSectionView(
                        color: Color(hex: "#64D2FF"),
                        title: "your_library".localized,
                        imageSystemName: "paintpalette.fill"
                    )
                }
                
            }

            //

            Section(footer: Text("reset_data_description".localized)) {
                Button {
                    isClearingData = true

                    DispatchQueue.global(qos: .userInitiated).async {
                        OfflineHelper.resetData(clearCaches: true)

                        DispatchQueue.main.async {
                            exitApplication()
                        }
                    }
                } label: {
                    if isClearingData {
                        ProgressView()
                    }
                    else {
                        Text("reset_data".localized)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())

        .animation(.default, value: isClearingData)

        .onAppear {
            WindowHelper.shared.overrideUserInterfaceStyle(.dark)
        }
    }
}
