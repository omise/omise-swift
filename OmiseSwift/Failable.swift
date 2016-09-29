import Foundation

public enum Failable<TResult> {
    case success(TResult)
    case fail(OmiseError)
}
