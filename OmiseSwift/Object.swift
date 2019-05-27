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

public protocol OmiseCreatedObject: OmiseObject {
    var createdDate: Date { get }
}

public protocol OmiseLiveModeObject: OmiseObject {
    var isLiveMode: Bool { get }
}


public protocol OmiseResourceObject: OmiseLocatableObject, OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatedObject {}

public protocol OmiseAPIPrimaryObject: OmiseLocatableObject {}

extension OmiseIdentifiableObject where Self: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OmiseLocatableObject where Self: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.location == rhs.location
    }
}

extension OmiseIdentifiableObject where Self: OmiseLocatableObject & Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OmiseAPIPrimaryObject {
    static func makeResourcePaths(id: String? = nil) -> [String] {
        var paths = [String]()
        
        paths.append(self.resourceInfo.path)
        if let id = id {
            paths.append(id)
        }
        
        return paths
    }
}

