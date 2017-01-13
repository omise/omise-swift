import Foundation


public struct Refund: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/refunds")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    public let isDeleted: Bool
    
    public let value: Value
    
    public let charge: DetailProperty<Charge>
    public let transaction: DetailProperty<Transaction>
}

extension Refund {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any], let omiseObjectProperties = Charge.parseOmiseResource(JSON: json) else {
            return nil
        }
        
        guard let value = Value(JSON: json), let charge = json["charge"].flatMap(DetailProperty<Charge>.init(JSON:)),
            let transaction = json["transaction"].flatMap(DetailProperty<Transaction>.init(JSON:)) else {
                return nil
        }
        (self.object, self.location, self.id, self.isLive, self.createdDate, self.isDeleted) = omiseObjectProperties
        
        self.value = value
        self.charge = charge
        self.transaction = transaction
    }
}
