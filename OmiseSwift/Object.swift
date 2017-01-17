import Foundation


public protocol OmiseObject {
    var object: String { get }
    
    init?(JSON: Any)
}

public protocol OmiseResourceObject: OmiseObject {
    static var resourceInfo: ResourceInfo { get }
    
    var id: String { get }
    var location: String { get }
    var isLive: Bool { get }
    var createdDate: Date { get }
    var isDeleted: Bool { get }
}

extension OmiseObject {
    static func parseObject(JSON json: Any) -> String? {
        guard let json = json as? [String: Any],
            let object = json["object"] as? String else {
                return nil
        }
        
        return (object: object)
    }
}

extension OmiseResourceObject {
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

extension OmiseResourceObject {
    static func parseOmiseResource(JSON json: Any) -> (object: String, location: String, id: String, isLive: Bool, createdDate: Date, isDeleted: Bool)? {
        guard let json = json as? [String: Any],
            let object = Self.parseObject(JSON: json),
            let location = json["location"] as? String,
            let id = json["id"] as? String,
            let isLive = json["livemode"] as? Bool,
            let createdDateString = json["created"] as? String,
            let created = DateConverter.convert(fromAttribute: createdDateString),
            let isDeleted = json["livemode"] as? Bool else {
                return nil
        }
        
        return (object: object, location: location, id: id, isLive: isLive, createdDate: created, isDeleted: isDeleted)
    }
}


extension OmiseResourceObject where Self: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
