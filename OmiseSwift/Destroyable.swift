import Foundation

public protocol Destroyable { }

public extension Destroyable where Self: ResourceObject {
    public typealias DestroyOperation = DefaultOperation<Self>
    
    public static func destroyOperation(parent: ResourceObject?) -> DestroyOperation {
        return DestroyOperation(
            endpoint: info.endpoint,
            method: "DELETE",
            paths: buildResourcePaths(self, parent: parent)
        )
    }
    
    public static func destroy(using given: Client? = nil, parent: ResourceObject? = nil, id: String, callback: Request<DestroyOperation>.Callback) -> Request<DestroyOperation>? {
        guard checkParent(self, parent: parent) else {
            return nil
        }
        
        let operation = self.destroyOperation(parent)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
