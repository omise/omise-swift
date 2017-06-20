import Foundation


public enum TransactionType: String, Codable {
    case debit
    case credit
}


public struct Transaction: OmiseIdentifiableObject, OmiseLocatableObject, OmiseCreatableObject {
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
}

extension Transaction {
    public init?(JSON json: Any) {
        guard let omiseObjectProperties = Transaction.parseOmiseProperties(JSON: json), let json = json as? [String: Any] else {
            return nil
        }
        
        guard let value = Value(JSON: json), let type: TransactionType = EnumConverter.convert(fromAttribute: json["type"]),
            let transferableDate = json["transferable"].flatMap(DateConverter.convert(fromAttribute:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.createdDate) = omiseObjectProperties
        
        self.currency = value.currency
        self.amount = value.amount
        self.type = type
        self.transferableDate = transferableDate
    }
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case createdDate = "created_date"
        case type
        case currency
        case amount
        case transferableDate = "transferable_date"
    }
}


extension Transaction: Listable {}
extension Transaction: Retrievable {}


