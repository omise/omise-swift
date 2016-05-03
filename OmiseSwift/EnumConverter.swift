import Foundation

public class EnumConverter<TEnum: RawRepresentable where TEnum.RawValue == String>: Converter {
    public typealias Target = TEnum
    
    public static func convertFromAttribute(value: NSObject?) -> Target? {
        guard let s = value as? String else { return nil }
        return TEnum(rawValue: s)
    }
    
    public static func convertToAttribute(value: Target?) -> NSObject? {
        guard let v = value else { return nil }
        return v.rawValue as NSString
    }
}
