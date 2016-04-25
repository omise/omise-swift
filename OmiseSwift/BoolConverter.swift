import Foundation

class BoolConverter: Converter {
    typealias TargetType = Bool
    
    static func convertFromAttribute(value: NSObject?) -> TargetType? {
        guard let n = value as? NSNumber else { return nil }
        return n.boolValue
    }
    
    static func convertToAttribute(value: TargetType?) -> NSObject? {
        guard let b = value else { return nil }
        return NSNumber(bool: b)
    }
}
