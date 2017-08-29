import Foundation

public protocol APIQuery: Encodable {}

public protocol APIURLQuery: APIQuery {}

public protocol APIJSONQuery: APIURLQuery {}

public protocol APIMultipartFormQuery: APIQuery {}

public protocol APIFileQuery: APIMultipartFormQuery {
    var filename: String { get }
    var fileContent: Data { get }
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
        
        let encoder = URLQueryItemEncoder()
        do {
            switch parameter {
            case .get(let query?):
                urlComponents.queryItems = try encoder.encode(query)
            case .head(let query?):
                urlComponents.queryItems = try encoder.encode(query)
            default:
                return url
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

