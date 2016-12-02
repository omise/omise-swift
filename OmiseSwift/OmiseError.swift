import Foundation

public enum OmiseError: Error {
    case unexpected(String)
    case configuration(String)
    case io(NSError)
    case api(APIError)
    
    public var message: String {
        switch self {
        case .unexpected(let message):
            return "unexpected error: \(message)"
        case .configuration(let message):
            return "configuration error: \(message)"
        case .io(let err):
            return "I/O error: \(err.description)"
        case .api(let err):
            return "(\(err.statusCode ?? 0)/\(err.code ?? "unknown")) \(err.message ?? "unknown error")"
        }
    }
}

extension OmiseError: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { return self.message }
    public var debugDescription: String { return self.message }
}

extension OmiseError: LocalizedError {
    public var errorDescription: String {
        return self.message
    }
}
