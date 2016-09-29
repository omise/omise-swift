import Foundation

open class ResourceObject: OmiseObject {
    class var info: ResourceInfo { return ResourceInfo() }
    
    var attachedClient: Client? = nil

    public var id: String? {
        get { return get("id", StringConverter.self) }
        set { set("id", StringConverter.self, toValue: newValue) }
    }
    
    public var live: Bool? {
        get { return get("livemode", BoolConverter.self) }
        set { set("livemode", BoolConverter.self, toValue: newValue) }
    }
    
    public var created: Date? {
        get { return get("created", DateConverter.self) }
        set { set("created", DateConverter.self, toValue: newValue) }
    }
    
    public var deleted: Bool? {
        get { return get("deleted", BoolConverter.self) }
        set { set("deleted", BoolConverter.self, toValue: newValue) }
    }
}
