import Foundation

class DateConverter: Converter {
    typealias TargetType = NSDate
    
    static let formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
    static func convertFromAttribute(value: NSObject?) -> TargetType? {
        guard let s = value as? NSString else { return nil }
        return formatter.dateFromString(s as String)
    }
    
    static func convertToAttribute(value: TargetType?) -> NSObject? {
        guard let d = value else { return nil }
        return formatter.stringFromDate(d)
    }
}
