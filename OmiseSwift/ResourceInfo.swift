import Foundation

public struct ResourceInfo {
    let parentType: OmiseResourceObject.Type?
    let path: String
    
    public init(parentType: OmiseResourceObject.Type? = nil, path: String) {
        self.parentType = parentType
        self.path = path
    }
}
