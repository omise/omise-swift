import Foundation

class DateProperty: Property {
    typealias TargetType = NSDate
    
    static let formatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
    static func get(model: Model, key: String) -> TargetType? {
        guard let s = model.attributes[key] as? String else {
            return nil
        }
        
        return formatter.dateFromString(s)
    }
    
    static func set(model: Model, key: String, toValue value: TargetType?) {
        if let v = value {
            model.attributes[key] = formatter.stringFromDate(v)
        } else {
            model.attributes[key] = nil
        }
    }
}
