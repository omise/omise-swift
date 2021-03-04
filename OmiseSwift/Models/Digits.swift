import Foundation


public struct Digits: Equatable {
    public let digits: String
    
    private static let invalidCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
    
    public init?(digitsString: String) {
        guard !digitsString.isEmpty &&
            digitsString.rangeOfCharacter(from: Digits.invalidCharacterSet) == nil else {
            return nil
        }
        
        self.digits = digitsString
    }
}

extension Digits: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(digits)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        guard !value.isEmpty &&
            value.rangeOfCharacter(from: Digits.invalidCharacterSet) == nil else {
                let context = DecodingError.Context(codingPath: decoder.codingPath,
                                                    debugDescription: "Invalid Digits value")
                throw DecodingError.dataCorrupted(context)
        }
        
        self.digits = value
    }
}

extension Digits: CustomStringConvertible {
    public var description: String {
        return digits
    }
}
