import Foundation


public struct DataID<Data: OmiseIdentifiableObject>: Hashable, Codable {
    public let idString: String
    
    public var isLiveMode: Bool {
        return !idString.contains("_test_")
    }
    
    public init?(idString: String) {
        guard Data.validate(id: idString) else {
            return nil
        }
        self.idString = idString
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let idString = try container.decode(String.self)
        if let id = DataID<Data>(idString: idString) {
            self = id
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid data ID value")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(idString)
    }
}

extension DataID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(idString: value)! // swiftlint:disable:this force_unwrapping
    }
}

extension DataID: CustomStringConvertible {
    public var description: String {
        return idString
    }
}
