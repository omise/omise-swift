import Foundation

public protocol Listable { }

public extension Listable where Self: ResourceObject {
    public typealias ListOperation = DefaultOperation<OmiseList<Self>>
    
    public static func list(using given: Client? = nil, callback: Request<ListOperation>.Callback?) -> Request<ListOperation>? {
        let client = resolveClient(given: given)
        return client.call(ListOperation(klass: self), callback: callback)
    }
}
