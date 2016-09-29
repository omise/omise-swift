import Foundation

public class EnumConverter<TEnum: RawRepresentable>: Converter where TEnum.RawValue == String {
    public typealias Target = TEnum
    
    public static func convert(fromAttribute value: Any?) -> Target? {
        guard let s = value as? String else { return nil }
        return TEnum(rawValue: s)
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        guard let v = value else { return nil }
        return v.rawValue
    }
}
