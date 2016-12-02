import Foundation

open class Operation<TResult: OmiseObject> {
    public typealias Result = TResult
    public typealias Callback = (Failable<TResult>) -> ()
    
    open let endpoint: Endpoint
    open let method: String
    open let pathComponents: [String]
    open let params: Params?
    
    open var url: URL {
        return makeURL()
    }
    
    open var payload: Data? {
        return makePayload()
    }
    
    public init(endpoint: Endpoint, method: String, paths: [String], params: Params? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.pathComponents = paths
        self.params = params
    }
    
    fileprivate func makeURL() -> URL {
        let url = endpoint.url(withComponents: pathComponents)
        
        guard method.uppercased() == "GET" || method.uppercased() == "HEAD" else {
            return url
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            omiseWarn("failed to build url components for url: \(url)")
            return url
        }
        
        if let params = self.params {
            urlComponents.queryItems = URLEncoder.encode(params.normalizedAttributes)
        }
        
        guard let parameterizedUrl = urlComponents.url else {
            omiseWarn("failed to append query items to the url: \(url)")
            return url
        }
        
        return parameterizedUrl
    }
    
    fileprivate func makePayload() -> Data? {
        guard let params = self.params else {
            return nil
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            omiseWarn("failed to build url components for url: \(url)")
            return nil
        }
        
        urlComponents.queryItems = URLEncoder.encode(params.normalizedAttributes)
        return urlComponents.percentEncodedQuery?.data(using: .utf8)
    }
}
