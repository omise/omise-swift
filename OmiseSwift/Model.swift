import Foundation

public class Model: NSObject {
    public typealias Attributes = [String: NSObject]
    
    public var attributes: Attributes
    
    public var object: String? {
        get { return StringProperty.get(self, key: "object") }
        set { StringProperty.set(self, key: "object", toValue: newValue) }
    }
    
    public var id: String? {
        get { return StringProperty.get(self, key: "id") }
        set { StringProperty.set(self, key: "id", toValue: newValue) }
    }
    
    public var location: String? {
        get { return StringProperty.get(self, key: "location") }
        set { StringProperty.set(self, key: "location", toValue: newValue) }
    }
    
    public var live: Bool? {
        get { return BoolProperty.get(self, key: "live") }
        set { BoolProperty.set(self, key: "live", toValue: newValue) }
    }
    
    public var created: NSDate? {
        get { return DateProperty.get(self, key: "created") }
        set { DateProperty.set(self, key: "created", toValue: newValue) }
    }
    
    public var deleted: Bool? {
        get { return BoolProperty.get(self, key: "deleted") }
        set { BoolProperty.set(self, key: "deleted", toValue: newValue) }
    }
    
    public init(attributes: [String: NSObject]) {
        self.attributes = attributes
        super.init()
    }
}
