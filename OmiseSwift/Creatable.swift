import Foundation

public protocol Creatable {
    associatedtype CreateParams: AttributesContainer
}

public protocol ScopedCreatable {
    associatedtype CreateParams: AttributesContainer
}

extension Creatable where Self: ResourceObject {
    public typealias CreateOperation = DefaultOperation<Self>
    
    public static func create(using given: Client? = nil, params: CreateParams, callback: Request<CreateOperation>.Callback) -> Request<CreateOperation>? {
        let operation = CreateOperation(klass: self, attributes: params.normalizedAttributes)
        operation.method = "POST"
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

extension ScopedCreatable where Self: ResourceObject {
    public typealias CreateOperation = DefaultOperation<Self>
    
    public static func create(using given: Client? = nil, parent: ResourceObject, params: CreateParams, callback: Request<CreateOperation>.Callback) -> Request<CreateOperation>? {
        let operation = CreateOperation(klass: parent.dynamicType, attributes: params.normalizedAttributes)
        operation.method = "POST"
        operation.pathComponents += [parent.id ?? "", self.resourcePath]
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
