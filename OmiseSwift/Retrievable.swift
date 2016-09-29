import Foundation

public protocol Retrievable { }

public extension Retrievable where Self: ResourceObject {
    public typealias RetrieveOperation = Operation<Self>
    
    public static func retrieveOperation(_ parent: ResourceObject?, id: String) -> RetrieveOperation {
        return RetrieveOperation(
            endpoint: info.endpoint,
            method: "GET",
            paths: makeResourcePathsWith(context: self, parent: parent, id: id)
        )
    }
    
    public static func retrieve(using given: Client? = nil, parent: ResourceObject? = nil, id: String, callback: @escaping RetrieveOperation.Callback) -> Request<RetrieveOperation.Result>? {
        guard checkParent(withContext: self, parent: parent) else {
            return nil
        }
        
        let operation = self.retrieveOperation(parent, id: id)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
