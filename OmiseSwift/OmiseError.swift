import Foundation

public enum OmiseError: Error {
    case unexpected(String)
    case configuration(String)
    case api(APIError)
    case other(Error)
    
    public var message: String {
        switch self {
        case .unexpected(let message):
            return "unexpected error: \(message)"
        case .configuration(let message):
            return "configuration error: \(message)"
        case .other(let err as DecodingError):
            return "Decoding Error: \(err.localizedDescription) - \(err.failureReason ?? "")"
        case .other(let err):
            return "I/O error: \(err.localizedDescription)"
        case .api(let err):
            let statusCode = err.statusCode.map({ "\($0)" }) ?? "(N/A)"
            return "(\(statusCode)/\(err.code)) \(err.message)"
        }
    }
}

extension OmiseError: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { return self.message }
    public var debugDescription: String { return self.message }
}

extension OmiseError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }
}
