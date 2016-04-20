import Foundation

public class Balance: Model {
    public var available: Int64? {
        get { return Int64Property.get(self, key: "available") }
        set { Int64Property.set(self, key: "available", toValue: newValue) }
    }
    
    public var total: Int64? {
        get { return Int64Property.get(self, key: "total") }
        set { Int64Property.set(self, key: "total", toValue: newValue) }
    }
    
    public var currency: String? {
        get { return StringProperty.get(self, key: "currency") }
        set { StringProperty.set(self, key: "currency", toValue: newValue) }
    }
}
