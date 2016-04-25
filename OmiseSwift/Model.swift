import Foundation

public class Model: NSObject {
    public typealias Attributes = [String: NSObject]
    
    public var attributes: Attributes
    
    public var object: String? {
        get { return get("object", StringConverter.self) }
        set { set("object", StringConverter.self, toValue: newValue) }
    }
    
    public var id: String? {
        get { return get("id", StringConverter.self) }
        set { set("id", StringConverter.self, toValue: newValue) }
    }
    
    public var location: String? {
        get { return get("location", StringConverter.self) }
        set { set("location", StringConverter.self, toValue: newValue) }
    }
    
    public var live: Bool? {
        get { return get("live", BoolConverter.self) }
        set { set("live", BoolConverter.self, toValue: newValue) }
    }
    
    public var created: NSDate? {
        get { return get("created", DateConverter.self) }
        set { set("created", DateConverter.self, toValue: newValue) }
    }
    
    public var deleted: Bool? {
        get { return get("deleted", BoolConverter.self) }
        set { set("deleted", BoolConverter.self, toValue: newValue) }
    }
    
    public init(attributes: [String: NSObject]) {
        self.attributes = attributes
        super.init()
    }
}
