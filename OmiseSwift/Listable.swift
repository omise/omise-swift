import Foundation

public protocol Listable { }

public extension Listable where Self: ResourceObject {
    typealias ListOperation = DefaultOperation<OmiseList<Self>>
    
    static func list(using given: Client? = nil, callback: Request<ListOperation>.Callback?) -> Request<ListOperation>? {
        let client = resolveClient(given: given)
        return client.call(ListOperation(klass: self), callback: callback)
    }
}
