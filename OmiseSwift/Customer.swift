import Foundation

public struct Customer: OmiseResourceObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/customers")
    
    public let location: String
    public let object: String
    
    public let id: String
    public let isLive: Bool
    public var createdDate: Date
    
    public let defaultCard: DetailProperty<Card>?
    public let email: String
    
    public var customerDescription: String?
    public var cards: ListProperty<Card>
    
    public let metadata: Dictionary<String, Any>
}


extension Customer {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseObjectProperties = Customer.parseOmiseResource(JSON: json) else {
                return nil
        }
        
        guard let email = json["email"] as? String,
            let cards = json["cards"].flatMap(ListProperty<Card>.init(JSON:)) else {
                return nil
        }
        
        (self.object, self.location, self.id, self.isLive, self.createdDate) = omiseObjectProperties
        
        self.email = email
        self.cards = cards
        self.defaultCard = json["default_card"].flatMap(DetailProperty<Card>.init(JSON:))
        self.customerDescription = json["description"] as? String
        
        self.metadata = json["metadata"] as? [String: Decodable & Any] ?? [:]
    }
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created_date"
        case defaultCard = "default_card"
        case email
        case customerDescription = "description"
        case cards
        case metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        location = try container.decode(String.self, forKey: .location)
        id = try container.decode(String.self, forKey: .id)
        isLive = try container.decode(Bool.self, forKey: .isLive)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        defaultCard = try container.decodeIfPresent(DetailProperty<Card>.self, forKey: .defaultCard)
        email = try container.decode(String.self, forKey: .email)
        customerDescription = try container.decode(String.self, forKey: .customerDescription)
        cards = try container.decode(ListProperty<Card>.self, forKey: .cards)
        metadata = try container.decodeIfPresent([String: Any].self, forKey: .metadata) ?? [:]
    }
}

public struct CustomerParams: APIJSONQuery {
    public var email: String?
    public var customerDescription: String?
    public var cardID: String?
    public var metadata: [String: Any]?
    
    public var json: JSONAttributes {
        return Dictionary.makeFlattenDictionaryFrom([
            "email": email,
            "description": customerDescription,
            "card": cardID,
            "metadata": metadata
            ])
    }
    
    public init(email: String? = nil, customerDescription: String? = nil, cardID: String? = nil, metadata: [String: Any]? = nil) {
        self.email = email
        self.customerDescription = customerDescription
        self.cardID = cardID
        self.metadata = metadata
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


