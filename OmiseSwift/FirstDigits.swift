import Foundation

public struct FirstDigits: Equatable {
    public let firstDigits: String
    
    public init?(firstDigitsString: String) {
        guard firstDigitsString != "" && firstDigitsString.rangeOfCharacter(from:
                CharacterSet(charactersIn: "0123456789").inverted) == nil
            else {
                return nil
        }
        
        self.firstDigits = firstDigitsString
    }
}

extension FirstDigits: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(firstDigits)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        guard value != "" && value.rangeOfCharacter(from:
                CharacterSet(charactersIn: "0123456789").inverted) == nil
            else {
                let context = DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid First Digits value")
                throw DecodingError.dataCorrupted(context)
        }
        
        self.firstDigits = value
    }
}

extension FirstDigits: CustomStringConvertible {
    public var description: String {
        return firstDigits
    }
}
