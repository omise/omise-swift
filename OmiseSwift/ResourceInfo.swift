import Foundation

public struct ResourceInfo {
    let parentType: OmiseResourceObject.Type?
    let endpoint: ServerEndpoint
    let path: String
    
    public init(parentType: OmiseResourceObject.Type? = nil, endpoint: ServerEndpoint = .api, path: String) {
        self.parentType = parentType
        self.endpoint = endpoint
        self.path = path
    }
}
