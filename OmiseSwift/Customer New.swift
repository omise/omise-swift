import Foundation

public struct Customer: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/customers")
    
    public let location: String
    public let object: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    public let isDeleted: Bool
    
    public let defaultCard: DetailProperty<Card>?
    public let email: String
    
    public var customerDescription: String?
    public var cards: ListProperty<Card>
}


extension Customer {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Charge.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let email = json["email"] as? String,
            let cards = json["cards"].flatMap(ListProperty<Card>.init(JSON:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate, self.isDeleted) = omiseObjectProperties
        
        self.email = email
        self.cards = cards
        self.defaultCard = json["default_card"].flatMap(DetailProperty<Card>.init(JSON:))
        self.customerDescription = json["description"] as? String
    }
}
