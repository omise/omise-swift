import Foundation

protocol ClientContainer {
    var attachedClient: Client? { get set }
}

func resolveClient(given client: Client? = nil, inside container: ClientContainer? = nil) throws -> Client {
    if let client = client {
        return client
    }
    
    if let client = container?.attachedClient {
        return client
    }
    
    return try getDefaultClient()
}
