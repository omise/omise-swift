import Foundation

class IntConverter: Converter {
    typealias TargetType = Int
    
    static func convertFromAttribute(value: NSObject?) -> TargetType? {
        guard let n = value as? NSNumber else { return nil }
        return n.integerValue
    }
    
    static func convertToAttribute(value: TargetType?) -> NSObject? {
        guard let n = value else { return nil }
        return NSNumber(long: n)
    }
}
