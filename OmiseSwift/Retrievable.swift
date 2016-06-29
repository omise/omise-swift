import Foundation

public protocol Retrievable { }

public extension Retrievable where Self: ResourceObject {
    public typealias RetrieveOperation = DefaultOperation<Self>
    
    public static func retrieve(using given: Client? = nil, callback: Request<RetrieveOperation>.Callback?) -> Request<RetrieveOperation>? {
        let operation = RetrieveOperation(
            endpoint: resourceEndpoint,
            method: "GET",
            paths: [resourcePath]
        )
        
        let client = resolveClient(given: given)
        return client.call(operation, callback: callback)
    }
}
