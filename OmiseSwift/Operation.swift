import Foundation

public protocol Operation: class {
    associatedtype Result: OmiseObject
    
    var endpoint: Endpoint { get }
    var method: String { get }
    var url: NSURL { get }
    var payload: NSData? { get }
}

public class DefaultOperation<TResult: OmiseObject>: Operation, AttributesContainer {
    public typealias Result = TResult
    
    public var attributes: JSONAttributes
    public var children: [String : AttributesContainer] = [:]
    
    public var endpoint: Endpoint = Endpoint.API
    public var method: String = "GET"
    public var path: String = "/"
    
    public var encodedAttributes: [NSURLQueryItem] {
        return URLEncoder.encode(attributes)
    }
    
    public var url: NSURL {
        return buildUrl()
    }
    
    public var payload: NSData? {
        return buildPayload()
    }
    
    public convenience init(klass: ResourceObject.Type, attributes: JSONAttributes = [:]) {
        self.init(attributes: attributes)
        self.endpoint = klass.resourceEndpoint
        self.path = klass.resourcePath
    }
    
    public required init(attributes: JSONAttributes = [:]) {
        self.attributes = attributes
    }
    
    private func buildUrl() -> NSURL {
        let url = endpoint.url.URLByAppendingPathComponent(path)
        guard method.uppercaseString == "GET" || method.uppercaseString == "HEAD" else {
            return url
        }
        
        guard let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) else {
            NSLog("failed to build url components for url: \(url)")
            return url
        }
        
        let queries = encodedAttributes
        guard queries.count > 0 else { return url }
        
        urlComponents.queryItems = URLEncoder.encode(attributes)
        guard let parameterizedUrl = urlComponents.URL else {
            NSLog("failed to append query items to the url: \(url)")
            return url
        }
        
        return parameterizedUrl
    }
    
    private func buildPayload() -> NSData? {
        guard let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) else {
            NSLog("failed to build url components for url: \(url)")
            return nil
        }
        
        let queries = encodedAttributes
        guard queries.count > 0 else { return nil }
        
        urlComponents.queryItems = URLEncoder.encode(attributes)
        return urlComponents.percentEncodedQuery?.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
