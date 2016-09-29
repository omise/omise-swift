import Foundation

public class StringConverter: Converter {
    public typealias Target = String
    
    public static func convert(fromAttribute value: Any?) -> String? {
        return value as? String
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        return value
    }
}
