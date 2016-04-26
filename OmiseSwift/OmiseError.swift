import Foundation

public enum OmiseError: ErrorType {
    case Unexpected(message: String)
    case Configuration(message: String)
    case API(err: APIError)
    
    var message: String {
        switch self {
        case .Unexpected(let message):
            return "unexpected error: \(message)"
        case .Configuration(let message):
            return "configuration error: \(message)"
        case .API(let err):
            return "(\(err.statusCode ?? 0)/\(err.code)) \(err.message)"
        }
    }
}
