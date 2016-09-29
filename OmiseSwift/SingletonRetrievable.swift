import Foundation

public protocol SingletonRetrievable { }

public extension SingletonRetrievable where Self: ResourceObject {
    public typealias SingletonRetrieveOperation = Operation<Self>
    
    public static func retrieveOperation(_ parent: ResourceObject?) -> SingletonRetrieveOperation {
        return SingletonRetrieveOperation(
            endpoint: info.endpoint,
            method: "GET",
            paths: makeResourcePathsWith(context: self, parent: parent)
        )
    }
    
    public static func retrieve(using given: Client? = nil, parent: ResourceObject? = nil, callback: SingletonRetrieveOperation.Callback?) -> Request<SingletonRetrieveOperation.Result>? {
        guard checkParent(withContext: self, parent: parent) else {
            return nil
        }
        
        let operation = self.retrieveOperation(parent)
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
