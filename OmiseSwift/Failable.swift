import Foundation

public enum Failable<TResult> {
    case Success(TResult)
    case Fail(OmiseError)
}
