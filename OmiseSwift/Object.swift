import Foundation


public protocol OmiseObject: Codable {
    var object: String { get }
}

public protocol OmiseLocatableObject: OmiseObject {
    static var resourceInfo: ResourceInfo { get }
    var location: String { get }
}

public protocol OmiseIdentifiableObject: OmiseObject {
    var id: String { get }
}

public protocol OmiseCreatableObject: OmiseObject {
    var createdDate: Date { get }
}

public protocol OmiseLiveModeObject: OmiseObject {
    var isLive: Bool { get }
}

public protocol OmiseResourceObject: OmiseLocatableObject, OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatableObject {}

extension OmiseLocatableObject {
    static func makeResourcePathsWithParent(_ parent: OmiseResourceObject? = nil, id: String? = nil) -> [String] {
        var paths = [String]()
        
        if let parent = parent {
            paths = [type(of: parent).resourceInfo.path, parent.id]
        }
        
        paths.append(self.resourceInfo.path)
        if let id = id {
            paths.append(id)
        }
        
        return paths
    }
    
    static func verifyParent(_ parent: OmiseResourceObject?) -> Bool {
        if let parentType = resourceInfo.parentType {
            guard let parent = parent, parentType == type(of: parent) else {
                return false
            }
        }
        
        return true
    }
}

