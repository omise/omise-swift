import Foundation

public protocol InstanceRetrievable { }
public protocol ScopedInstanceRetrievable { }

public extension InstanceRetrievable where Self: ResourceObject {
    public typealias InstanceRetrieveOperation = DefaultOperation<Self>
    
    public static func retrieve(using given: Client? = nil, id: String, callback: Request<InstanceRetrieveOperation>.Callback) -> Request<InstanceRetrieveOperation>? {
        let operation = InstanceRetrieveOperation(klass: self)
        operation.path += "/\(URLEncoder.encodeURLPath(id))"
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}

public extension ScopedInstanceRetrievable where Self: ResourceObject {
    public typealias InstanceRetrieveOperation = DefaultOperation<Self>
    
    public static func retrieve(using given: Client? = nil, parent: ResourceObject, id: String, callback: Request<InstanceRetrieveOperation>.Callback) -> Request<InstanceRetrieveOperation>? {
        let operation = InstanceRetrieveOperation(klass: parent.dynamicType)
        operation.path += "/\(parent.id ?? "")\(self.resourcePath)"
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}