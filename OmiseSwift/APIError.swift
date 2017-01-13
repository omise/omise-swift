import Foundation

public struct APIError: OmiseObject {
    public let object: String
    
    public let statusCode: Int
    public let code: String
    public let message: String
    
    
    public init?(JSON json : Any) {
        guard let json = json as? [String: Any],
            let object = APIError.parseObject(JSON: json),
            let statusCode = json["status_code"] as? Int,
            let code = json["code"] as? String,
            let message = json["message"] as? String else {
                return nil
        }
        
        self.object = object
        self.code = code
        self.statusCode = statusCode
        self.message = message
        
    }
}

extension APIError: Error {
}
