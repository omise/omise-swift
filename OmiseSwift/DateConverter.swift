import Foundation

public class DateConverter: Converter {
    public typealias Target = Date
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
    static let iso8601Formatter: Formatter = {
        if #available(iOSApplicationExtension 10.0, *) {
            return ISO8601DateFormatter()
        } else {
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            return formatter
        }
    }()
    
    public static func convert(fromAttribute value: Any?) -> Target? {
        guard let s = value as? String else { return nil }
        return formatter.date(from: s)
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        guard let d = value else { return nil }
        return iso8601Formatter.string(for: d)
    }
}
