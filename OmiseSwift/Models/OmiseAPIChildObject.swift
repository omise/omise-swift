import Foundation


public protocol OmiseAPIChildObject: OmiseLocatableObject & OmiseIdentifiableObject {
    associatedtype Parent: OmiseResourceObject & OmiseAPIPrimaryObject
}


extension OmiseAPIChildObject where Self: OmiseLocatableObject & OmiseIdentifiableObject {
    static func makeResourcePathsWith(parent: Parent, id: DataID<Self>? = nil) -> [String] {
        var paths = [String]()
        
        paths = [type(of: parent).resourcePath, parent.id.idString]
        paths.append(self.resourcePath)
        if let id = id {
            paths.append(id.idString)
        }
        
        return paths
    }
}

