import Foundation

public struct APIError: OmiseLocatableObject, CustomDebugStringConvertible {
    
    /**
     An API Error Code enum represent error from Omise API.
     
     - seealso: [Omise: API Error Codes](https://www.omise.co/api-errors)
     */
    public enum APIErrorCode: CustomDebugStringConvertible {
        case authenticationFailure
        case notFound
        case usedToken
        case invalidAmount
        case invalidBankAccount
        case invalidCard
        case invalidCardToken
        case invalidFilter
        case invalidPage
        case invalidScope
        case missingCard
        case invalidCharge
        case failedCapture
        case expiredCharge
        case failedVoid
        
        case other(String)
        
        init(code: String) {
            switch code {
            case "authentication_failure":
                self = .authenticationFailure
            case "not_found":
                self = .notFound
            case "used_token":
                self = .usedToken
            case "invalid_amount":
                self = .invalidAmount
            case "invalid_bank_account":
                self = .invalidBankAccount
            case "invalid_card":
                self = .invalidCard
            case "invalid_card_token":
                self = .invalidCardToken
            case "invalid_scope":
                self = .invalidScope
            case "invalid_filter":
                self = .invalidFilter
            case "invalid_page":
                self = .invalidPage
            case "missing_card":
                self = .missingCard
            case "invalid_charge":
                self = .invalidCharge
            case "failed_capture":
                self = .failedCapture
            case "expired_charge":
                self = .expiredCharge
            case "failed_void":
                self = .failedVoid
            case let code:
                self = .other(code)
            }
        }
        
        var code: String {
            switch self {
            case .authenticationFailure:
                return "authentication_failure"
            case .notFound:
                return "not_found"
            case .usedToken:
                return "used_token"
            case .invalidAmount:
                return "invalid_amount"
            case .invalidBankAccount:
                return "invalid_bank_account"
            case .invalidCard:
                return "invalid_card"
            case .invalidCardToken:
                return "invalid_card_token"
            case .invalidScope:
                return "invalid_scope"
            case .invalidFilter:
                return "invalid_filter"
            case .invalidPage:
                return "invalid_page"
            case .missingCard:
                return "missing_card"
            case .invalidCharge:
                return "invalid_charge"
            case .failedCapture:
                return "failed_capture"
            case .expiredCharge:
                return "expired_charge"
            case .failedVoid:
                return "failed_void"
            case .other(let code):
                return code
            }
        }
        
        public var debugDescription: String {
            switch self {
            case .authenticationFailure:
                return "Authentication Failure"
            case .notFound:
                return "Not Found"
            case .usedToken:
                return "Used Token"
            case .invalidAmount:
                return "Invalid Amount"
            case .invalidBankAccount:
                return "Invalid Bank Account"
            case .invalidCard:
                return "Invalid Card"
            case .invalidCardToken:
                return "Invalid Card Token"
            case .invalidScope:
                return "Invalid Scope"
            case .invalidFilter:
                return "Invalid Filter"
            case .invalidPage:
                return "Invalid Page"
            case .missingCard:
                return "Missing Card"
            case .invalidCharge:
                return "Invalid Charge"
            case .failedCapture:
                return "Failed Capture"
            case .expiredCharge:
                return "Expired Charge"
            case .failedVoid:
                return "Failed Void"
            case .other(let code):
                return code
            }
        }
    }
    
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/api-errors")
    
    public let object: String
    public let location: String
    
    public let statusCode: Int?
    public let code: APIErrorCode
    public let message: String
    
    
    public init?(JSON json : Any) {
        guard let json = json as? [String: Any],
            let properties = APIError.parseLocationResource(JSON: json),
            let code = (json["code"] as? String).map(APIErrorCode.init(code:)),
            let message = json["message"] as? String else {
                return nil
        }
        
        (self.object, self.location) = properties
        self.code = code
        self.statusCode = json["status_code"] as? Int
        self.message = message
    }
    
    public var debugDescription: String {
        return "Error: \(code.debugDescription) - \(message) [\(location)]"
    }
}

extension APIError: Error {}

