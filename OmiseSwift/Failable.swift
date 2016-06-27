import Foundation

public enum Failable<TResult> {
    case Success(result: TResult)
    case Fail(err: OmiseError)
}
