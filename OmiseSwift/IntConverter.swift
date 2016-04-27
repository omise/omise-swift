import Foundation

public class IntConverter: Converter {
    public typealias Target = Int
    
    public static func convertFromAttribute(value: NSObject?) -> Target? {
        guard let n = value as? NSNumber else { return nil }
        return n.integerValue
    }
    
    public static func convertToAttribute(value: Target?) -> NSObject? {
        guard let n = value else { return nil }
        return NSNumber(long: n)
    }
}
