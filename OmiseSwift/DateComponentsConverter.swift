import Foundation

public class DateComponentsConverter: Converter {
    public typealias Target = NSDateComponents
    
    static func makeScanner(forString string: String) -> NSScanner {
        let scanner = NSScanner(string: string)
        let validCharacterSet = NSCharacterSet(charactersInString: "0123456789-")
        scanner.charactersToBeSkipped = validCharacterSet.invertedSet
        return scanner
    }
    
    public static func convertFromAttribute(value: NSObject?) -> Target? {
        guard let s = value as? String else { return nil }
        let scanner = makeScanner(forString: s)
        let year: Int
        let month: Int
        let day: Int
        
        var firstInt: Int = 0
        var secondInt: Int = 0
        var lastInt: Int = 0
        guard scanner.scanInteger(&firstInt) &&
            scanner.scanString("-", intoString: nil) &&
            scanner.scanInteger(&secondInt) &&
            scanner.scanString("-", intoString: nil) &&
            scanner.scanInteger(&lastInt) &&
            scanner.scanString("-", intoString: nil)
            else {
                return nil
        }
        
        month = secondInt
        let isYearFirst = firstInt > 12
        if isYearFirst {
            year = firstInt
            day = lastInt
        } else {
            day = firstInt
            year = lastInt
        }
        
        let components = NSDateComponents()
        components.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        components.year = year
        components.month = month
        components.day = day
        
        return components
    }
    
    public static func convertToAttribute(value: Target?) -> NSObject? {
        guard let dateComponents = value where
            (dateComponents.calendar?.calendarIdentifier ?? NSCalendar.currentCalendar().calendarIdentifier) == NSCalendarIdentifierGregorian else { return nil }
        return "\(dateComponents.year)-\(dateComponents.month)-\(dateComponents.day)"
    }
}
