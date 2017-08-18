import Foundation

public protocol APIQuery {}

public protocol APIURLQuery: APIQuery {
    var queryItems: [URLQueryItem] { get }
}

public protocol APIJSONQuery: APIURLQuery {
    var json: JSONAttributes { get }
}

public protocol APIMultipartFormQuery: APIQuery {
    
}

public protocol APIFileQuery: APIMultipartFormQuery {
    var filename: String { get }
    var fileContent: Data { get }
}

extension APIJSONQuery {
    public var queryItems: [URLQueryItem] {
        return encodeDict(json, parentKey: nil)
            .sorted(by: { (item1, item2) in item1.name < item2.name })
    }
}


public struct APIEndpoint<DataType: OmiseObject> {
    
    public enum Parameter {
        case get(APIURLQuery?)
        case head(APIURLQuery?)
        case post(APIQuery?)
        case patch(APIQuery?)
        case delete
        
        var method: String {
            switch self {
            case .get:
                return "GET"
            case .head:
                return "HEAD"
            case .post:
                return "POST"
            case .patch:
                return "PATCH"
            case .delete:
                return "DELETE"
            }
        }
    }
    
    public typealias Result = DataType
    
    public let endpoint: ServerEndpoint
    public let parameter: Parameter
    public let pathComponents: [String]
    
    init(endpoint: ServerEndpoint = .api, pathComponents: [String], parameter: Parameter) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.parameter = parameter
    }
    
    func makeURL() -> URL {
        let url = endpoint.url(withComponents: pathComponents)
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            omiseWarn("failed to build url components for url: \(url)")
            return url
        }
        
        switch parameter {
        case .get(let query?):
            urlComponents.queryItems = query.queryItems
        case .head(let query?):
            urlComponents.queryItems = query.queryItems
        default:
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

