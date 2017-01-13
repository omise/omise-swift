import Foundation

public class BankAccount: ResourceObject {
    public var brand: String? {
        get { return get("brand", StringConverter.self) }
        set { set("brand", StringConverter.self, toValue: newValue) }
    }
    
    public var lastDigits: LastDigits? {
        get { return get("last_digits", LastDigitsConverter.self) }
        set { set("last_digits", LastDigitsConverter.self, toValue: newValue) }
    }
        
    public var name: String? {
        get { return get("name", StringConverter.self) }
        set { set("name", StringConverter.self, toValue: newValue) }
    }
}
