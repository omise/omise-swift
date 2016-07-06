import Foundation

public protocol Creatable {
    associatedtype CreateParams: Params
}

public extension Creatable where Self: ResourceObject {
    public typealias CreateOperation = DefaultOperation<Self>
    
    public static func create(using given: Client? = nil, parent: ResourceObject? = nil, params: CreateParams, callback: Request<CreateOperation>.Callback) -> Request<CreateOperation>? {
        guard checkParent(self, parent: parent) else {
            return nil
        }
        
        let operation = CreateOperation(
            endpoint: info.endpoint,
            method: "POST",
            paths: buildResourcePaths(self, parent: parent),
            params: params
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
