import Foundation

public protocol Destroyable { }

public extension Destroyable where Self: ResourceObject {
    public typealias DestroyOperation = Operation<Self>
    
    public static func destroyOperation(_ parent: ResourceObject?, id: String) -> DestroyOperation {
        return DestroyOperation(
            endpoint: info.endpoint,
            method: "DELETE",
            paths: makeResourcePathsWith(context: self, parent: parent, id: id)
        )
    }
    
    public static func destroy(using given: Client? = nil, parent: ResourceObject? = nil, id: String, callback: @escaping DestroyOperation.Callback) -> Request<DestroyOperation.Result>? {
        guard checkParent(withContext: self, parent: parent) else {
            return nil
        }
        
        let operation = self.destroyOperation(parent, id: id)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
