import Foundation

protocol Retrievable {
}

extension Retrievable where Self: ResourceObject {
    static func retrieve(using given: Client? = nil, callback: Request<DefaultOperation<Self>>.Callback?) -> Request<DefaultOperation<Self>>? {
        let client = resolveClient(given: given)
        
        let operation: DefaultOperation<Self> = DefaultOperation()
        operation.endpoint = self.resourceEndpoint
        operation.method = "GET"
        operation.path = self.resourcePath
        
        return client.call(operation, callback: callback)
    }
}
