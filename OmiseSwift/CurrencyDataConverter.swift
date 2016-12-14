import Foundation


public class CurrencyDataConverter: Converter {
    public typealias Target = Currency
    
    public static func convert(fromAttribute value: Any?) -> Target? {
        guard let s = value as? String else { return nil }
        return Currency(code: s)
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        guard let v = value else { return nil }
        return v.code
    }
}
