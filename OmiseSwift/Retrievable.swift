import Foundation

public protocol Retrievable { }

public extension Retrievable where Self: ResourceObject {
    public typealias RetrieveOperation = DefaultOperation<Self>
    
    public static func retrieve(using given: Client? = nil, parent: ResourceObject? = nil, callback: Request<RetrieveOperation>.Callback?) -> Request<RetrieveOperation>? {
        guard checkParent(self, parent: parent) else {
            return nil
        }
        
        let operation = RetrieveOperation(
            endpoint: info.endpoint,
            method: "GET",
            paths: buildResourcePaths(self, parent: parent)
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
