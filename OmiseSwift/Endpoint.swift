import Foundation

public enum ServerEndpoint: String {
    case vault = "https://vault.omise.co"
    case api = "https://api.omise.co"
    
    var url: URL {
        return URL(string: rawValue)!
    }
    
    func url(withComponents components: [String]) -> URL {
        return components.reduce(url, { (url, segment) -> URL in
            return url.appendingPathComponent(segment)
        })
    }
}
