import Foundation

public class Account: ResourceObject {
    public var email: String? {
        get { return get("email", StringConverter.self) }
        set { set("email", StringConverter.self, toValue: newValue) }
    }
}
