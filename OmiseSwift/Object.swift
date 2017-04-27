import Foundation


public protocol OmiseObject {
    var object: String { get }
    
    init?(JSON: Any)
}

public protocol OmiseLocatableObject: OmiseObject {
    static var resourceInfo: ResourceInfo { get }
    
    var location: String { get }
}

public protocol OmiseIdentifiableObject: OmiseObject {
    var id: String { get }
    var createdDate: Date { get }
}

public protocol OmiseLiveModeObject: OmiseObject {
    var isLive: Bool { get }
}

public protocol OmiseResourceObject: OmiseLocatableObject, OmiseIdentifiableObject, OmiseLiveModeObject {
}

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


extension OmiseObject {
    static func parseObject(JSON json: Any) -> String? {
        guard let json = json as? [String: Any],
            let object = json["object"] as? String else {
                return nil
        }
        
        return object
    }
}

extension OmiseLiveModeObject {
    static func parseOmiseProperties(JSON json: Any) -> (object: String, isLiveMode: Bool)? {
        guard let json = json as? [String: Any],
            let object = Self.parseObject(JSON: json),
            let isLive = json["livemode"] as? Bool else {
                return nil
        }
        
        return (object: object, isLiveMode: isLive)
    }
}

extension OmiseLocatableObject {
    static func parseLocationResource(JSON json: Any) -> (object: String, location: String)? {
        guard let json = json as? [String: Any],
            let object = Self.parseObject(JSON: json),
            let location = json["location"] as? String else {
                return nil
        }
        
        return (object: object, location: location)
    }
}

func parseDate(_ date: Any) -> Date? {
    return (date as? Date) ?? (date as? String).flatMap(DateConverter.convert(fromAttribute:))
}

extension OmiseIdentifiableObject {
    static func parseIdentifiableProperties(JSON json: Any) -> (object: String, id: String, createdDate: Date)? {
        guard let json = json as? [String: Any],
            let object = Self.parseObject(JSON: json),
            let id = json["id"] as? String,
            let created = json["created"].flatMap(parseDate) else {
                return nil
        }
        
        return (object: object, id: id, createdDate: created)
    }
}

extension OmiseLiveModeObject where Self: OmiseIdentifiableObject {
    static func parseOmiseProperties(JSON json: Any) -> (object: String, isLiveMode: Bool, id: String, createdDate: Date)? {
        guard let json = json as? [String: Any],
            let object = Self.parseObject(JSON: json),
            let isLiveMode = json["livemode"] as? Bool,
            let id = json["id"] as? String,
            let created = json["created"].flatMap(parseDate) else {
                return nil
        }
        
        return (object: object, isLiveMode: isLiveMode, id: id, createdDate: created)
    }
}


extension OmiseLocatableObject where Self: OmiseIdentifiableObject {
    static func parseOmiseProperties(JSON json: Any) -> (object: String, location: String, id: String, createdDate: Date)? {
        guard let json = json as? [String: Any],
            let object = Self.parseObject(JSON: json),
            let location = json["location"] as? String,
            let id = json["id"] as? String,
            let created = json["created"].flatMap(parseDate) else {
                return nil
        }
        
        return (object: object, location: location, id: id, createdDate: created)
    }
}

extension OmiseResourceObject {
    static func parseOmiseResource(JSON json: Any) -> (object: String, location: String, id: String, isLive: Bool, createdDate: Date)? {
        guard let json = json as? [String: Any],
            let object = Self.parseObject(JSON: json),
            let location = json["location"] as? String,
            let id = json["id"] as? String,
            let isLive = json["livemode"] as? Bool,
            let created = json["created"].flatMap(parseDate) else {
                return nil
        }
        
        return (object: object, location: location, id: id, isLive: isLive, createdDate: created)
    }
}


extension OmiseIdentifiableObject where Self: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
