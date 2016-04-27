import Foundation

public class BoolConverter: Converter {
    public typealias Target = Bool
    
    public static func convertFromAttribute(value: NSObject?) -> Target? {
        guard let n = value as? NSNumber else { return nil }
        return n.boolValue
    }
    
    public static func convertToAttribute(value: Target?) -> NSObject? {
        guard let b = value else { return nil }
        return NSNumber(bool: b)
    }
}
