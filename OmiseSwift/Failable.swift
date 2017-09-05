import Foundation

public enum Failable<TResult> {
    case success(TResult)
    case fail(OmiseError)
    
    public func map<T>(_ transform: (TResult) -> T) -> Failable<T> {
        switch self {
        case .success(let result):
            return Failable<T>.success(transform(result))
        case .fail(let error):
            return Failable<T>.fail(error)
        }
    }
}

/*public init(from decoder: Decoder) throws {
 do {
 let error = try APIError(from: decoder)
 self = .fail(OmiseError.api(error))
 } catch is DecodingError {
 let result = try TResult(from: decoder)
 self = .success(result)
 }
 }*/

