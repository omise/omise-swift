import Foundation

public enum Endpoint: String {
    case vault = "https://vault.omise.co"
    case api = "https://api.omise.co"
    
    var url: URL {
        guard let url = URL(string: rawValue) else {
            NSLog("error building endpoint url from: \(rawValue)")
          return URL(string: "")!
        }
        
        return url
    }
    
    func url(withComponents components: [String]) -> URL {
        return components.reduce(url, { (url, segment) -> URL in
            return url.appendingPathComponent(segment)
        })
    }
}
