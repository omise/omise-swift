import Foundation

public protocol InstanceRetrievable { }

public extension InstanceRetrievable where Self: ResourceObject {
    public typealias InstanceRetrieveOperation = DefaultOperation<Self>
    
    public static func retrieve(using given: Client? = nil, parent: ResourceObject? = nil, id: String, callback: Request<InstanceRetrieveOperation>.Callback) -> Request<InstanceRetrieveOperation>? {
        guard checkParent(self, parent: parent) else {
            return nil
        }
        
        let operation = InstanceRetrieveOperation(
            endpoint: info.endpoint,
            method: "GET",
            paths: buildResourcePaths(self, parent: parent, id: id)
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}