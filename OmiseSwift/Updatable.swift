import Foundation

public protocol Updatable {
    associatedtype UpdateParams: AttributesContainer
}

extension Updatable where Self: ResourceObject {
    public typealias UpdateOperation = DefaultOperation<Self>
    
    public static func update(using given: Client? = nil, id: String, params: UpdateParams, callback: Request<UpdateOperation>.Callback) -> Request<UpdateOperation>? {
        let operation = UpdateOperation(klass: self, attributes: params.normalizedAttributes)
        operation.method = "POST"
        operation.path += "/\(URLEncoder.encodeURLPath(id))"
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
