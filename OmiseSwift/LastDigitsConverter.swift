import Foundation

public class LastDigitsConverter: Converter {
    public typealias Target = LastDigits
    
    public static func convert(fromValue value: LastDigits?) -> Any? {
        return value?.lastDigits
    }
    
    public static func convert(fromAttribute value: Any?) -> LastDigits? {
        guard let digitsString = value as? String else { return nil }
        return LastDigits(lastDigitsString: digitsString)
    }
}
