import Foundation

public class DateConverter: Converter {
    public typealias Target = NSDate
    
    static let formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
    public static func convertFromAttribute(value: NSObject?) -> Target? {
        guard let s = value as? NSString else { return nil }
        return formatter.dateFromString(s as String)
    }
    
    public static func convertToAttribute(value: Target?) -> NSObject? {
        guard let d = value else { return nil }
        return formatter.stringFromDate(d)
    }
}
