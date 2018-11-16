import Foundation


public enum TransactionType: String, Codable, Equatable {
    case debit
    case credit
}


public struct Transaction: OmiseIdentifiableObject, OmiseLocatableObject, OmiseCreatableObject, Equatable {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/transactions")
    
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
    
    public let source: String // TODO: Handle the expand case
    
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


