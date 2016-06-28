import Foundation

public class Event: ResourceObject {
    public override class var resourcePath: String { return "/events" }
    
    public var key: String? {
        get { return get("key", StringConverter.self) }
        set { set("key", StringConverter.self, toValue: newValue) }
    }
    
    public var data: ResourceObject? {
        get {
            guard let dataJson = attributes["data"] as? JSONAttributes else { return nil }
            guard let object = dataJson["object"] as? String else { return nil }
            guard let klass = Lookup.resourceTypeFromName[object] else { return nil }
            return getChild("data", klass)
        }
        set {
            setChild("data", ResourceObject.self, toValue: newValue)
        }
    }
}

extension Event: Listable { }
extension Event: InstanceRetrievable { }