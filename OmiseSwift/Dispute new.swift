import Foundation

public enum DisputeStatus: String {
    case open
    case pending
    case won
    case lost
    case closed
}


public struct Dispute: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/disputes")
    
    public let object: String
    public let location: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    public let isDeleted: Bool
    
    public let value: Value
    public var status: DisputeStatus
    public let message: String
    public let charge: DetailProperty<Charge>
}


extension Dispute {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Charge.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let value = Value(JSON: json), let status = json["status"].flatMap(EnumConverter<DisputeStatus>.convert(fromAttribute:)),
        let message = json["message"] as? String,
            let charge = json["charge"].flatMap(DetailProperty<Charge>.init(JSON:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate, self.isDeleted) = omiseObjectProperties
        self.value = value
        self.status = status
        self.message = message
        self.charge = charge
    }
}

