import Foundation

public struct APIError: OmiseLocatableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/api-errors")
    
    public let object: String
    public let location: String
    
    public let statusCode: Int?
    public let code: String
    public let message: String
    
    
    public init?(JSON json : Any) {
        guard let json = json as? [String: Any],
            let properties = APIError.parseLocationResource(JSON: json),
            let code = json["code"] as? String,
            let message = json["message"] as? String else {
                return nil
        }
        
        (self.object, self.location) = properties
        self.code = code
        self.statusCode = json["status_code"] as? Int
        self.message = message
    }
}

extension APIError: Error {}
