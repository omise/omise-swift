import Foundation

public protocol Creatable {
    associatedtype CreateParams: AttributesContainer
}

extension Creatable where Self: ResourceObject {
    public typealias CreateOperation = DefaultOperation<Self>
    
    public static func create(using given: Client? = nil, params: CreateParams, callback: Request<CreateOperation>.Callback) -> Request<CreateOperation>? {
        let operation = CreateOperation(klass: self, attributes: params.attributes)
        operation.method = "POST"
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
