import Foundation

enum ChromeYouTube {
    static func playbackURL(from address: String) -> URL? {
        guard let page = URLComponents(string: address),
              page.scheme == "https" || page.scheme == "http" else { return nil }
        let path = page.path.split(separator: "/")
        let id: String?
        switch page.host?.lowercased() {
        case "youtu.be":
            id = path.count == 1 ? path.first.map(String.init) : nil
        case "youtube.com", "www.youtube.com", "m.youtube.com":
            if page.path == "/watch" {
                id = page.queryItems?.first(where: { $0.name == "v" })?.value
            } else if path.count == 2, ["shorts", "live", "embed"].contains(path[0]) {
                id = String(path[1])
            } else {
                id = nil
            }
        default:
            return nil
        }
        guard let id, id.range(of: #"\A[A-Za-z0-9_-]{11}\z"#, options: .regularExpression) != nil else {
            return nil
        }
        return URL(string: "youtube://watch/\(id)")
    }
}
