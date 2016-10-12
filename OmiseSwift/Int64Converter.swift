import Foundation

public class Int64Converter: Converter {
    public typealias Target = Int64
    
    public static func convert(fromAttribute value: Any?) -> Target? {
        switch value {
        case let n as Int64:
            return n
        case let n as NSNumber:
            return n.int64Value
        default:
            return nil
        }
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        guard let n = value else { return nil }
        return NSNumber(value: n)
    }
}
