import Foundation

public class Account: Model {
    public var email: String? {
        get { return StringProperty.get(self, key: "email") }
        set { StringProperty.set(self, key: "email", toValue: newValue) }
    }
}
