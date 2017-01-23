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

public struct CustomerParams: APIParams {
    public var email: String?
    public var customerDescription: String?
    public var cardID: String?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "email": email,
            "description": customerDescription,
            "card": cardID
            ])
    }
    
    public init(email: String? = nil, customerDescription: String? = nil, cardID: String? = nil) {
        self.email = email
        self.customerDescription = customerDescription
        self.cardID = cardID
    }
}

public struct CustomerFilterParams: OmiseFilterParams {

    public var created: DateComponents?

    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "created": DateComponentsConverter.convert(fromValue: created)
            ])
    }
    
    public init(created: DateComponents?) {
        self.created = created
    }

    public init(JSON: [String : Any]) {
        self.init(
            created: JSON["created"].flatMap(DateComponentsConverter.convert(fromAttribute:))
        )
    }
}

extension Customer: Listable {}
extension Customer: Retrievable {}

extension Customer: Creatable {
    public typealias CreateParams = CustomerParams
}

extension Customer: Updatable {
    public typealias UpdateParams = CustomerParams
}

extension Customer: Searchable {
    public typealias FilterParams = CustomerFilterParams
}

extension Customer: Destroyable {}


