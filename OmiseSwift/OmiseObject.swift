import Foundation

open class OmiseObject: NSObject, AttributesContainer {
    open var attributes: JSONAttributes = [:]
    open var children: [String: AttributesContainer] = [:]
    
    public var object: String? {
        get { return get("object", StringConverter.self) }
        set { set("object", StringConverter.self, toValue: newValue) }
    }
    
    public var location: String? {
        get { return get("location", StringConverter.self) }
        set { set("location", StringConverter.self, toValue: newValue) }
    }
    
    public required override init() {
        super.init()
    }
    
    public required init(attributes: JSONAttributes) {
        self.attributes = attributes
        super.init()
    }
}
