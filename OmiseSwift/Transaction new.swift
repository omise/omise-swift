import Foundation


public enum TransactionType: String {
    case debit
    case credit
}


public struct Transaction: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/transactions")
    
    public let object: String
    public let location: String

    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    public let isDeleted: Bool
    
    public let type: TransactionType
    public let value: Value
    
    public let transferableDate: Date
}

extension Transaction {
    public init?(JSON json: Any) {
        guard let omiseObjectProperties = Transaction.parseOmiseResource(JSON: json), let json = json as? [String: Any] else {
            return nil
        }
        
        guard let value = Value(JSON: json), let type: TransactionType = EnumConverter.convert(fromAttribute: json["type"]),
            let transferableDate = json["transferable"].flatMap(DateConverter.convert(fromAttribute:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate, self.isDeleted) = omiseObjectProperties
        
        self.value = value
        self.type = type
        self.transferableDate = transferableDate
    }
}


extension Transaction: Listable { }
extension Transaction: Retrievable { }


