import Foundation

public class BoolConverter: Converter {
    public typealias Target = Bool
    
    public static func convert(fromAttribute value: Any?) -> Target? {
        guard let n = value as? Bool else { return nil }
        return n
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        guard let b = value else { return nil }
        return b
    }
}
