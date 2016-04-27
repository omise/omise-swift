import Foundation

public protocol Operation: class {
    associatedtype Result
    
    var endpoint: Endpoint { get }
    var method: String { get }
    var url: NSURL { get }
    var payload: NSData? { get }
}

public class DefaultOperation<TResult: OmiseObject>: Operation, AttributesContainer {
    public typealias Result = TResult
    
    public var attributes: JSONAttributes = [:]
    
    public var endpoint: Endpoint {
        return Endpoint.API
    }
    
    public var method: String {
        return "GET"
    }
    
    public var path: String {
        return "/"
    }
    
    public var url: NSURL {
        return buildUrl()
    }
    
    public var queryItems: [NSURLQueryItem] {
        return []
    }
    
    public var payload: NSData? {
        return buildPayload()
    }
    
    public required init() {
    }
    
    private func buildUrl() -> NSURL {
        let url = endpoint.url.URLByAppendingPathComponent(path)
        
        switch method.uppercaseString {
        case "GET", "HEAD":
            guard let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) else {
                NSLog("failed to build url components for url: \(url)")
                return url
            }
            
            let queries = URLEncoder.encode(attributes)
            guard queries.count > 0 else { return url }
            
            urlComponents.queryItems = URLEncoder.encode(attributes)
            guard let parameterizedUrl = urlComponents.URL else {
                NSLog("failed to append query items to the url: \(url)")
                return url
            }
            
            return parameterizedUrl
            
        default:
            return url
        }
    }
    
    private func buildPayload() -> NSData? {
        guard let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) else {
            NSLog("failed to build url components for url: \(url)")
            return nil
        }
        
        let queries = URLEncoder.encode(attributes)
        guard queries.count > 0 else { return nil }
        
        urlComponents.queryItems = URLEncoder.encode(attributes)
        return urlComponents.percentEncodedQuery?.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
