import Foundation

public enum OmiseError: ErrorType {
    case Unexpected(String)
    case Configuration(String)
    case IO(NSError)
    case API(APIError)
    
    public var message: String {
        switch self {
        case .Unexpected(let message):
            return "unexpected error: \(message)"
        case .Configuration(let message):
            return "configuration error: \(message)"
        case .IO(let err):
            return "I/O error: \(err.description)"
        case .API(let err):
            return "(\(err.statusCode ?? 0)/\(err.code ?? "unknown")) \(err.message ?? "unknown error")"
        }
    }
}

extension OmiseError: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { return self.message }
    public var debugDescription: String { return self.message }
}
