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

extension Failable: Equatable where TResult: Equatable {
    public static func == (lhs: Failable<TResult>, rhs: Failable<TResult>) -> Bool {
        switch (lhs, rhs) {
        case let (.success(lhsResult), .success(rhsResult)):
            return lhsResult == rhsResult
        case let (.fail(lhsError), .fail(rhsError)):
            return lhsError == rhsError
        case (.success, .fail), (.fail, .success): return false
        }
    }
}

