import Foundation

public class Int64Converter: Converter {
    public typealias Target = Int64
    
    public static func convertFromAttribute(value: NSObject?) -> Target? {
        guard let n = value as? NSNumber else { return nil }
        return n.longLongValue
    }
    
    public static func convertToAttribute(value: Target?) -> NSObject? {
        guard let n = value else { return nil }
        return NSNumber(longLong: n)
    }
}
