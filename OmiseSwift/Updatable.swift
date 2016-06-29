import Foundation

public protocol Updatable {
    associatedtype UpdateParams: Params
}

public protocol ScopedUpdatable {
    associatedtype UpdateParams: Params
}

extension Updatable where Self: ResourceObject {
    public typealias UpdateOperation = DefaultOperation<Self>
    
    public static func update(using given: Client? = nil, id: String, params: UpdateParams, callback: Request<UpdateOperation>.Callback) -> Request<UpdateOperation>? {
        let operation = UpdateOperation(
            endpoint: resourceEndpoint,
            method: "PATCH",
            paths: [resourcePath, id],
            params: params
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

extension ScopedUpdatable where Self: ResourceObject {
    public typealias UpdateOperation = DefaultOperation<Self>
    
    public static func update(using given: Client? = nil, parent: ResourceObject, id: String, params: UpdateParams, callback: Request<UpdateOperation>.Callback) -> Request<UpdateOperation>? {
        let operation = UpdateOperation(
            endpoint: resourceEndpoint,
            method: "PATCH",
            paths: [parent.dynamicType.resourcePath, parent.id ?? "", resourcePath, id],
            params: params
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
