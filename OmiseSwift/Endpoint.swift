import Foundation

let stagingURLSuffix = "-staging.omise.co"
let productionURLSuffix = ".omise.co"

public enum ServerEndpoint {
    case vault(AccessKey)
    case api
    
    var url: URL {
        let urlString: String
        switch self {
        case .vault:
            urlString = "https://vault" + productionURLSuffix
        case .api:
            urlString = "https://api" + productionURLSuffix
        }
        return URL(string: urlString)!
    }
    
    func url(withComponents components: [String]) -> URL {
        return components.reduce(url, { (url, segment) -> URL in
            return url.appendingPathComponent(segment)
        })
    }
}
