import Foundation

public protocol Updatable {
    associatedtype UpdateParams: Params
}

public extension Updatable where Self: ResourceObject {
    public typealias UpdateOperation = DefaultOperation<Self>
    
    public static func update(using given: Client? = nil, parent: ResourceObject? = nil, id: String, params: UpdateParams, callback: Request<UpdateOperation>.Callback) -> Request<UpdateOperation>? {
        guard checkParent(self, parent: parent) else {
            return nil
        }
        
        let operation = UpdateOperation(
            endpoint: info.endpoint,
            method: "PATCH",
            paths: buildResourcePaths(self, parent: parent, id: id),
            params: params
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
