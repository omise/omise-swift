import Foundation

public class OmiseObject: NSObject {
    public typealias Attributes = [String: NSObject]
    public var attributes: Attributes = [:]
    
    public var object: String? {
        get { return get("object", StringConverter.self) }
        set { set("object", StringConverter.self, toValue: newValue) }
    }
    
    public var location: String? {
        get { return get("location", StringConverter.self) }
        set { set("location", StringConverter.self, toValue: newValue) }
    }
    
    public required override init() {
        self.attributes = [:]
    }
    
    public required init(attributes: [String: NSObject]) {
        self.attributes = attributes
        super.init()
    }
}
