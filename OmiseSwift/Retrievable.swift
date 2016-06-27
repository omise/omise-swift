import Foundation

protocol Retrievable {
}

extension Retrievable where Self: OmiseObject {
    static func retrieve(using client: Client? = nil, callback: Request<DefaultOperation<Self>>.Callback?) throws -> Request<DefaultOperation<Self>>? {
        let client = try resolveClient(given: client)
        
        let operation: DefaultOperation<Self> = DefaultOperation()
        operation.method = "GET"
        // operation.url = resourcePath // TODO:
        
        return client.call(operation, callback: callback)
    }
}
