import Foundation


public protocol OmiseObject: Codable {
    var object: String { get }
}

public protocol OmiseLocatableObject: OmiseObject, Hashable {
    static var resourcePath: String { get }
    var location: String { get }
}

public protocol OmiseIdentifiableObject: OmiseObject, Hashable {
    var id: DataID<Self> { get }
    static var idPrefix: String { get }
    
    static func validate(id: String) -> Bool
}

public protocol OmiseCreatedObject: OmiseObject {
    var createdDate: Date { get }
}

public protocol OmiseLiveModeObject: OmiseObject {
    var isLiveMode: Bool { get }
}


public protocol OmiseResourceObject: OmiseLocatableObject, OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatedObject {}

public protocol OmiseAPIPrimaryObject: OmiseLocatableObject {}


public extension OmiseIdentifiableObject {
    static func validate(id: String) -> Bool {
        return id.range(of:
            #"^\#(Self.idPrefix)(_test)?_[0-9a-z]+$"#,
            options: [.regularExpression, .anchored]) != nil
    }
}

public extension OmiseIdentifiableObject {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension OmiseLocatableObject {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.location == rhs.location
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
    }
}

public extension OmiseIdentifiableObject where Self: OmiseLocatableObject {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.location == rhs.location
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location)
        hasher.combine(id)
    }
}

extension OmiseAPIPrimaryObject {
    static func makeResourcePaths() -> [String] {
        var paths = [String]()
        paths.append(self.resourcePath)
        return paths
    }
}

extension OmiseAPIPrimaryObject where Self: OmiseIdentifiableObject {
    static func makeResourcePaths(id: DataID<Self>? = nil) -> [String] {
        var paths = [String]()
        
        paths.append(self.resourcePath)
        if let id = id {
            paths.append(id.idString)
        }
        
        return paths
    }
}
