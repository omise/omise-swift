import Foundation

public protocol Retrievable { }

public extension Retrievable where Self: ResourceObject {
    public typealias RetrieveOperation = DefaultOperation<Self>
    
    public static func retrieve(using given: Client? = nil, callback: Request<RetrieveOperation>.Callback?) -> Request<RetrieveOperation>? {
        let client = resolveClient(given: given)
        return client.call(RetrieveOperation(klass: self), callback: callback)
    }
}
