import Foundation

public protocol Destroyable { }

extension Destroyable where Self: ResourceObject {
    public typealias DestroyOperation = DefaultOperation<Self>
    
    public static func destroy(using given: Client? = nil, id: String, callback: Request<DestroyOperation>.Callback) -> Request<DestroyOperation>? {
        let operation = DestroyOperation(klass: self)
        operation.method = "DELETE"
        operation.path += "/\(URLEncoder.encodeURLPath(id))"
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
