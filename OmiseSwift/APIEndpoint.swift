import Foundation

public struct APIEndpoint<DataType: OmiseObject> {
    
    public typealias Result = DataType
    
    public let endpoint: ServerEndpoint
    public let method: String
    public let pathComponents: [String]
    public let params: APIDataSerializable?
    
    
    func makeURL() -> URL {
        let url = endpoint.url(withComponents: pathComponents)
        
        guard method.uppercased() == "GET" || method.uppercased() == "HEAD" else {
            return url
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            omiseWarn("failed to build url components for url: \(url)")
            return url
        }
        
        if let params = self.params {
            urlComponents.queryItems = encode(params)
        }
        
        guard let parameterizedUrl = urlComponents.url else {
            omiseWarn("failed to append query items to the url: \(url)")
            return url
        }
        
        return parameterizedUrl
    }
    
    func makePayload() -> Data? {
        guard let params = self.params else {
            return nil
        }
        
        guard var urlComponents = URLComponents(url: makeURL(), resolvingAgainstBaseURL: true) else {
            omiseWarn("failed to build url components for url: \(makeURL())")
            return nil
        }
        
        urlComponents.queryItems = encode(params)
        return urlComponents.percentEncodedQuery?.data(using: .utf8)
    }
    
    func serializePayload() throws -> Data? {
        return try params.map({ try JSONSerialization.data(withJSONObject: $0.json, options: []) })
    }
    
    func deserialize(_ data: Data) throws -> DataType {
        return try deserialize(data)
    }
}

