import Foundation

public protocol Creatable {
    associatedtype CreateParams: Params
}

public extension Creatable where Self: ResourceObject {
    public typealias CreateOperation = Operation<Self>
    
    public static func createOperation(_ parent: ResourceObject?, params: CreateParams) -> CreateOperation {
        return CreateOperation(
            endpoint: info.endpoint,
            method: "POST",
            paths: makeResourcePathsWith(context: self, parent: parent),
            params: params
        )
    }
    
    public static func create(using given: Client? = nil, parent: ResourceObject? = nil, params: CreateParams, callback: @escaping CreateOperation.Callback) -> Request<CreateOperation.Result>? {
        guard checkParent(withContext: self, parent: parent) else {
            return nil
        }
        
        let operation = self.createOperation(parent, params: params)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
