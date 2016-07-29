import Foundation

public class Operation<TResult: OmiseObject> {
    public typealias Result = TResult
    public typealias Callback = Failable<TResult> -> ()
    
    public let endpoint: Endpoint
    public let method: String
    public let pathComponents: [String]
    public let params: Params?
    
    public var url: NSURL {
        return buildUrl()
    }
    
    public var payload: NSData? {
        return buildPayload()
    }
    
    public init(endpoint: Endpoint, method: String, paths: [String], params: Params? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.pathComponents = paths
        self.params = params
    }
    
    private func buildUrl() -> NSURL {
        let url = pathComponents.reduce(endpoint.url) { (url, segment) -> NSURL in
            return url.URLByAppendingPathComponent(segment)
        }
        
        guard method.uppercaseString == "GET" || method.uppercaseString == "HEAD" else {
            return url
        }
        
        guard let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) else {
            omiseWarn("failed to build url components for url: \(url)")
            return url
        }
        
        if let params = self.params {
            urlComponents.queryItems = URLEncoder.encode(params.normalizedAttributes)
        }
        
        guard let parameterizedUrl = urlComponents.URL else {
            omiseWarn("failed to append query items to the url: \(url)")
            return url
        }
        
        return parameterizedUrl
    }
    
    private func buildPayload() -> NSData? {
        guard let params = self.params else {
            return nil
        }
        
        guard let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) else {
            omiseWarn("failed to build url components for url: \(url)")
            return nil
        }
        
        urlComponents.queryItems = URLEncoder.encode(params.normalizedAttributes)
        return urlComponents.percentEncodedQuery?.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
