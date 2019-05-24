import Foundation


public struct Transaction<Source: OmiseIdentifiableObject>: OmiseIdentifiableObject, OmiseLocatableObject, OmiseCreatableObject, Equatable {
    public static var resourceInfo: ResourceInfo {
        return ResourceInfo(path: "/transactions")
    }
    
    public let object: String
    public let location: String
    public let isLive: Bool
    public let id: String
    public var createdDate: Date
    
    public let direction: Direction
    public let key: String
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    public let amount: Int64
    public let currency: Currency
    
    public let transferableDate: Date
    
    public let origin: DetailProperty<Source>
    
    public enum Direction: String, Codable, Equatable {
        case debit
        case credit
    }
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created_at"
        case direction
        case key
        case currency
        case amount
        case transferableDate = "transferable_at"
        case origin
    }
}


extension Transaction: Listable {}
extension Transaction: Retrievable {}


