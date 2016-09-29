import Foundation

public class APIError: OmiseObject {
    public var statusCode: Int? {
        get { return get("status_code", IntConverter.self) }
        set { set("status_code", IntConverter.self, toValue: newValue) }
    }
    
    public var code: String? {
        get { return get("code", StringConverter.self) }
        set { set("code", StringConverter.self, toValue: newValue) }
    }
    
    public var message: String? {
        get { return get("message", StringConverter.self) }
        set { set("message", StringConverter.self, toValue: newValue) }
    }
}

extension APIError: Error {
}
