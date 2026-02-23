import SwiftUI

struct OmneonSettingsVersionView: View {
    @State private var latestVersion: String?

    private func loadVersion() async {
        do {
            latestVersion = try await GithubServant.shared.getLatestRelease()
        } catch {
            latestVersion = "Unknown"
        }
    }
    
    private var isUpdateAvailable: Bool {
        guard let latest = latestVersion else { return false }
    
        NSLog("[Omneon] Latest: %@", latest)
        NSLog("[Omneon] Installed: %@", Omneon.version)
    
        let result = latest.compare(Omneon.version, options: .numeric) == .orderedDescending
    
        NSLog("[Omneon] Update Available? %@", result ? "YES" : "NO")
    
        return result
    }

    var body: some View {
        Section {
            if isUpdateAvailable {
                Link(
                    "update_available".localized,
                    destination: URL(string: "https://github.com/abysxx")!
                )
            }
        } footer: {
            VStack(alignment: .leading) {
                Text("v\(Omneon.version)")

                if latestVersion == nil {
                    HStack(spacing: 10) {
                        ProgressView()
                        Text("checking_for_update".localized)
                    }
                }
            }
        }

        .animation(.default, value: latestVersion)

        .onAppear {
            Task {
                try await loadVersion()
            }
        }
    }
}
