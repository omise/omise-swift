import Foundation

public enum Endpoint: String {
    case Vault = "https://vault.omise.co"
    case API = "https://api.omise.co"
    
    var url: NSURL {
        guard let url = NSURL(string: rawValue) else {
            NSLog("error building endpoint url from: \(rawValue)")
            return NSURL()
        }
        
        return url
    }
}
