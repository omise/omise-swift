import Foundation

public struct ResourceInfo {
    let parentType: ResourceObject.Type?
    let endpoint: Endpoint
    let path: String
    
    public init(parentType: ResourceObject.Type? = nil, endpoint: Endpoint = .API, path: String = "/") {
        self.parentType = parentType
        self.endpoint = endpoint
        self.path = path
    }
}
