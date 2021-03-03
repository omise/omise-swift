import Foundation


public typealias ListAPIEndpoint<Result: OmiseObject> = APIEndpoint<ListParams, ListProperty<Result>>


public struct APIEndpoint<QueryType: APIQuery, DataType: OmiseObject> {
    
    public typealias Result = DataType
    
    public let endpoint: ServerEndpoint
    public let pathComponents: [String]
    public let query: QueryType?
    let method: HTTPMethod
    
    enum HTTPMethod: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    init(endpoint: ServerEndpoint = .api, pathComponents: [String], method: HTTPMethod, query: QueryType?) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.method = method
        self.query = query
    }
    
    func makeURL() -> URL {
        let url = endpoint.url(withComponents: pathComponents)
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            omiseWarn("failed to build url components for url: \(url)")
            return url
        }
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        do {
            if let query = self.query {
                switch method {
                case .get, .head:
                    urlComponents.queryItems = try encoder.encode(query)
                default:
                    return url
                }
            }
        } catch {
            return url
        }
        
        guard let parameterizedUrl = urlComponents.url else {
            omiseWarn("failed to append query items to the url: \(url)")
            return url
        }
        
        return parameterizedUrl
    }
    
    func deserialize(_ data: Data) throws -> DataType {
        return try deserializeData(data)
    }
}


extension APIEndpoint where QueryType == NoAPIQuery {
    init(endpoint: ServerEndpoint = .api, pathComponents: [String], method: HTTPMethod) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.method = method
        self.query = nil
    }
}
