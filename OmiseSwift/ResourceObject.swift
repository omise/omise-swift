import Foundation

public class ResourceObject: OmiseObject {
    var attachedClient: Client? = nil
    
    public class var resourcePath: String { return "/" }
    public class var resourceEndpoint: Endpoint { return Endpoint.API }

    public var id: String? {
        get { return get("id", StringConverter.self) }
        set { set("id", StringConverter.self, toValue: newValue) }
    }
    
    public var live: Bool? {
        get { return get("livemode", BoolConverter.self) }
        set { set("livemode", BoolConverter.self, toValue: newValue) }
    }
    
    public var created: NSDate? {
        get { return get("created", DateConverter.self) }
        set { set("created", DateConverter.self, toValue: newValue) }
    }
    
    public var deleted: Bool? {
        get { return get("deleted", BoolConverter.self) }
        set { set("deleted", BoolConverter.self, toValue: newValue) }
    }
}
