import Foundation

class Int64Converter: Converter {
    typealias TargetType = Int64
    
    static func convertFromAttribute(value: NSObject?) -> TargetType? {
        guard let n = value as? NSNumber else { return nil }
        return n.longLongValue
    }
    
    static func convertToAttribute(value: TargetType?) -> NSObject? {
        guard let n = value else { return nil }
        return NSNumber(longLong: n)
    }
}
