import Foundation

public class DoubleConverter: Converter {
    public typealias Target = Double
    
    public static func convert(fromAttribute value: Any?) -> Target? {
        switch value {
        case let n as Double:
            return n
        case let n as NSNumber:
            return n.doubleValue
        default:
            return nil
        }
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        guard let n = value else { return nil }
        return n
    }
}
