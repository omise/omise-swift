import Foundation

public protocol Updatable {
    associatedtype UpdateParams: AttributesContainer
}

public protocol ScopedUpdatable {
    associatedtype UpdateParams: AttributesContainer
}

extension Updatable where Self: ResourceObject {
    public typealias UpdateOperation = DefaultOperation<Self>
    
    public static func update(using given: Client? = nil, id: String, params: UpdateParams, callback: Request<UpdateOperation>.Callback) -> Request<UpdateOperation>? {
        let operation = UpdateOperation(klass: self, attributes: params.normalizedAttributes)
        operation.method = "PATCH"
        operation.pathComponents += [id]
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

extension ScopedUpdatable where Self: ResourceObject {
    public typealias UpdateOperation = DefaultOperation<Self>
    
    public static func update(using given: Client? = nil, parent: ResourceObject, id: String, params: UpdateParams, callback: Request<UpdateOperation>.Callback) -> Request<UpdateOperation>? {
        let operation = UpdateOperation(klass: parent.dynamicType, attributes: params.normalizedAttributes)
        operation.method = "PATCH"
        operation.pathComponents += [parent.id ?? "", self.resourcePath, id]
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
