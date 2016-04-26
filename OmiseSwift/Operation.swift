import Foundation

public class Operation<TResult: OmiseObject> {
    public let endpoint: Endpoint
    public let method: String
    public let url: NSURL
    public let payload: NSData?
    
    public init(endpoint: Endpoint, method: String, path: String, values: OmiseObject.Attributes) {
        self.endpoint = endpoint
        self.method = method.uppercaseString
        
        let url = endpoint.url.URLByAppendingPathComponent(path)
        guard let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) else {
            NSLog("failed to build url components for url: \(url)")
            self.url = url
            self.payload = nil
            return
        }
        
        let queryItems = URLEncoder.encode(values)
        if queryItems.count > 0 {
            urlComponents.queryItems = queryItems
        }
        
        switch method.uppercaseString {
        case "GET", "HEAD":
            guard let completeUrl = urlComponents.URL else {
                NSLog("failed to rebuild url from components of url: \(url)")
                self.url = url
                self.payload = nil
                return
            }
            
            self.url = completeUrl
            self.payload = nil
            
        default:
            guard let payloadString = urlComponents.percentEncodedQuery else {
                NSLog("failed to build request payload for url: \(url)")
                self.url = url
                self.payload = nil
                return
            }
            
            self.url = url
            self.payload = payloadString.dataUsingEncoding(NSUTF8StringEncoding)
        }
    }
}
