import Foundation

public class OmiseError: OmiseObject {
    public var code: String? {
        get { return get("code", StringConverter.self) }
        set { set("code", StringConverter.self, toValue: newValue) }
    }
    
    public var message: String? {
        get { return get("message", StringConverter.self) }
        set { set("message", StringConverter.self, toValue: newValue) }
    }
}

extension OmiseError: ErrorType {
}
