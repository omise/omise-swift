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
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case id
        case isLive = "livemode"
        case createdDate = "created"
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(object, forKey: .object)
        try container.encode(location, forKey: .location)
        try container.encode(id, forKey: .id)
        try container.encode(isLive, forKey: .isLive)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encodeIfPresent(defaultCard, forKey: .defaultCard)
        try container.encode(email, forKey: .email)
        try container.encode(customerDescription, forKey: .customerDescription)
        try container.encode(cards, forKey: .cards)
        try container.encode(metadata, forKey: .metadata)
    }
}

public struct CustomerParams: APIJSONQuery {
    public var email: String?
    public var customerDescription: String?
    public var cardID: String?
    public var metadata: [String: Any]?
    
    private enum CodingKeys: String, CodingKey {
        case email
        case customerDescription = "description"
        case cardID = "card"
        case metadata
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(customerDescription, forKey: .customerDescription)
        try container.encodeIfPresent(cardID, forKey: .cardID)
        if let metadata = metadata, !metadata.isEmpty {
            try container.encodeIfPresent(metadata, forKey: .metadata)
        }
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
    
    private enum CodingKeys: String, CodingKey {
        case created
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        created = try container.decodeIfPresent(String.self, forKey: .created).flatMap(DateComponentsConverter.convert(fromAttribute:))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(DateComponentsConverter.convert(fromValue: created), forKey: .created)
    }
    
    public init(created: DateComponents?) {
        self.created = created
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


