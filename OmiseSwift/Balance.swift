import Foundation

public class Balance: ResourceObject {
    public var available: Int64? {
        get { return get("available", Int64Converter.self) }
        set { set("available", Int64Converter.self, toValue: newValue) }
    }
    
    public var total: Int64? {
        get { return get("total", Int64Converter.self) }
        set { set("total", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: String? {
        get { return get("currency", StringConverter.self) }
        set { set("currency", StringConverter.self, toValue: newValue) }
    }
}
