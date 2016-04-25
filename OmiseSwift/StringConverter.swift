import Foundation

class StringConverter: Converter {
    typealias TargetType = String
    
    static func convertFromAttribute(value: NSObject?) -> TargetType? {
        if let str = value as? String {
            return str
        } else {
            return nil
        }
    }
    
    static func convertToAttribute(value: TargetType?) -> NSObject? {
        if let s = value {
            return NSString(string: s)
        } else {
            return nil
        }
    }
}