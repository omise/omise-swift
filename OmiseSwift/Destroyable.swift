import Foundation

public protocol Destroyable { }
public protocol ScopedDestroyable { }

extension Destroyable where Self: ResourceObject {
    public typealias DestroyOperation = DefaultOperation<Self>
    
    public static func destroy(using given: Client? = nil, id: String, callback: Request<DestroyOperation>.Callback) -> Request<DestroyOperation>? {
        let operation = DestroyOperation(
            endpoint: info.endpoint,
            method: "DELETE",
            paths: [info.path, id]
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

extension ScopedDestroyable where Self: ResourceObject {
    public typealias DestroyOperation = DefaultOperation<Self>
    
    public static func create(using given: Client? = nil, parent: ResourceObject, id: String, callback: Request<DestroyOperation>.Callback) -> Request<DestroyOperation>? {
        let operation = DestroyOperation(
            endpoint: info.endpoint,
            method: "DELETE",
            paths: [parent.dynamicType.info.path, parent.id ?? "", info.path, id]
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
