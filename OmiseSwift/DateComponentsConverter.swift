import Foundation

public class DateComponentsConverter: Converter {
    public typealias Target = DateComponents
    
    static func makeScanner(forString string: String) -> Scanner {
        let scanner = Scanner(string: string)
        let validCharacterSet = CharacterSet(charactersIn: "0123456789-")
        scanner.charactersToBeSkipped = validCharacterSet.inverted
        return scanner
    }
    
    public static func convert(fromAttribute value: Any?) -> Target? {
        guard let s = value as? String else { return nil }
        let scanner = makeScanner(forString: s)
        let year: Int
        let month: Int
        let day: Int
        
        var firstInt: Int = 0
        var secondInt: Int = 0
        var lastInt: Int = 0
        guard scanner.scanInt(&firstInt) &&
            scanner.scanString("-", into: nil) &&
            scanner.scanInt(&secondInt) &&
            scanner.scanString("-", into: nil) &&
            scanner.scanInt(&lastInt) &&
            scanner.scanString("-", into: nil)
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
        
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        
        components.year = year
        components.month = month
        components.day = day
        
        return components
    }
    
    public static func convert(fromValue value: Target?) -> Any? {
        guard let dateComponents = value,
            (dateComponents.calendar?.identifier ?? Calendar.current.identifier) == .gregorian,
        let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day else { return nil }
        return "\(year)-\(month)-\(day)"
    }
}
