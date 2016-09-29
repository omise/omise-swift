import Foundation

public class Int64Converter: Converter {
    public typealias Target = Int64
    
    public static func convert(fromAttribute value: Any?) -> Target? {
        guard let n = value as? NSNumber else { return nil }
        return n.int64Value
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        guard let n = value else { return nil }
        return n
    }
}
