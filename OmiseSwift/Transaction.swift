import Foundation


public enum TransactionType: String, Codable, Equatable {
    case debit
    case credit
}


public struct Transaction<Source: OmiseIdentifiableObject>: OmiseIdentifiableObject, OmiseLocatableObject, OmiseCreatableObject, Equatable {
    public static var resourceInfo: ResourceInfo {
        return ResourceInfo(path: "/transactions")
    }
    
    public let object: String
    public let location: String

    public let id: String
    public var createdDate: Date
    
    public let type: TransactionType
    public var value: Value {
        return Value(amount: amount, currency: currency)
    }
    
    public let amount: Int64
    public let currency: Currency
    
    public let transferableDate: Date
    
    public let source: DetailProperty<Source>
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case createdDate = "created"
        case type
        case currency
        case amount
        case transferableDate = "transferable"
        case source
    }
}


extension Transaction: Listable {}
extension Transaction: Retrievable {}


