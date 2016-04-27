import Foundation

public class StringConverter: Converter {
    public typealias Target = String
    
    public static func convertFromAttribute(value: NSObject?) -> Target? {
        if let str = value as? String {
            return str
        } else {
            return nil
        }
    }
    
    public static func convertToAttribute(value: Target?) -> NSObject? {
        if let s = value {
            return NSString(string: s)
        } else {
            return nil
        }
    }
}