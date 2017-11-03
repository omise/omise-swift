import Foundation

public struct LastDigits {
    public let lastDigits: String
    
    public init?(lastDigitsString: String) {
        guard lastDigitsString.count == 4 && lastDigitsString.rangeOfCharacter(from: CharacterSet.init(charactersIn: "0123456789").inverted) == nil else {
            return nil
        }
        
        self.lastDigits = lastDigitsString
    }
}

extension LastDigits: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(lastDigits)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        guard value.count == 4 && value.rangeOfCharacter(from: CharacterSet.init(charactersIn: "0123456789").inverted) == nil else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid Last Digits value")
            throw DecodingError.dataCorrupted(context)
        }
        
        self.lastDigits = value
    }
}

extension LastDigits: Equatable {
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: LastDigits, rhs: LastDigits) -> Bool {
        return lhs.lastDigits == rhs.lastDigits
    }
}

