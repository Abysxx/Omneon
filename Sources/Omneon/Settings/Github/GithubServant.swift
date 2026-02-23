import Foundation

struct GithubServant {
    private let apiUrl = "https://raw.githubusercontent.com"

    static let shared = GithubServant()

    private init() { }

    private func perform(_ path: String) async throws -> Data {
        let url = URL(string: "\(apiUrl)\(path)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

    func getLatestRelease() async throws -> String {
        let data = try await perform("/Abysxx/Omneon/refs/heads/main/OmneonVersion.txt")
        guard let text = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "GithubServant", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid UTF8"])
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
