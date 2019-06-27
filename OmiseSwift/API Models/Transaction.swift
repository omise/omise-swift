import Foundation


public struct Transaction<Origin: OmiseIdentifiableObject>: OmiseResourceObject, Equatable {
    public static var resourcePath: String {
        return "/transactions"
    }
    public static var idPrefix: String {
        return "trxn"
    }
    
    public let object: String
    public let location: String
    public let isLiveMode: Bool
    public let id: DataID<Transaction<Origin>>
    public let createdDate: Date
    
    public let direction: Direction
    public let key: String
    
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    public let amount: Int64
    public let currency: Currency
    
    public let transferableDate: Date
    
    public let origin: DetailProperty<Origin>
    
    public enum Direction: String, Codable, Equatable {
        case debit
        case credit
    }
}

extension Transaction {
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        case direction
        case key
        case currency
        case amount
        case transferableDate = "transferable_at"
        case origin
    }
}


extension Transaction: OmiseAPIPrimaryObject {}
extension Transaction: Listable {}
extension Transaction: Retrievable {}


