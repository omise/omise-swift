import Foundation

public protocol Creatable {
    associatedtype CreateParams: Params
}

public protocol ScopedCreatable {
    associatedtype CreateParams: Params
}

extension Creatable where Self: ResourceObject {
    public typealias CreateOperation = DefaultOperation<Self>
    
    public static func create(using given: Client? = nil, params: CreateParams, callback: Request<CreateOperation>.Callback) -> Request<CreateOperation>? {
        let operation = CreateOperation(
            endpoint: resourceEndpoint,
            method: "POST",
            paths: [resourcePath],
            params: params
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

extension ScopedCreatable where Self: ResourceObject {
    public typealias CreateOperation = DefaultOperation<Self>
    
    public static func create(using given: Client? = nil, parent: ResourceObject, params: CreateParams, callback: Request<CreateOperation>.Callback) -> Request<CreateOperation>? {
        let operation = CreateOperation(
            endpoint: resourceEndpoint,
            method: "POST",
            paths: [parent.dynamicType.resourcePath, parent.id ?? "", resourcePath],
            params: params
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
