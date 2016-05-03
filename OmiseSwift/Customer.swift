import Foundation

public class Customer: ResourceObject {
    public var defaultCard: String? {
        get { return get("default_card", StringConverter.self) }
        set { set("default_card", StringConverter.self, toValue: newValue) }
    }
    
    public var email: String? {
        get { return get("email", StringConverter.self) }
        set { set("email", StringConverter.self, toValue: newValue) }
    }
    
    public var customerDescription: String? {
        get { return get("description", StringConverter.self) }
        set { set("description", StringConverter.self, toValue: newValue) }
    }
    
    public var cards: OmiseList<Card>? {
        get { return getChild("cards", OmiseList<Card>.self) }
        set { setChild("cards", OmiseList<Card>.self, toValue: newValue) }
    }
}
