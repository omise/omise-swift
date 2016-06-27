import Foundation

public protocol InstanceRetrievable { }

public extension InstanceRetrievable where Self: ResourceObject {
    typealias InstanceRetrieveOperation = DefaultOperation<Self>
    
    public static func retrieve(using given: Client? = nil, id: String, callback: Request<InstanceRetrieveOperation>.Callback?) -> Request<InstanceRetrieveOperation>? {
        let operation = InstanceRetrieveOperation(klass: self)
        operation.path += "/\(URLEncoder.encodeURLPath(id))"
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}